extends Node
## Um arquivo local para o protótipo. Não é um sistema de slots.

const SAVE_VERSION: int = 1
const SAFE_ROOM: String = "test_room_01"
const SAFE_POSITION: Vector2 = Vector2(520, 644)

@export var save_path: String = "user://deia_slot_1.json"


func save_game(vitals: Node) -> bool:
	var data: Dictionary = {
		"version": SAVE_VERSION,
		"room": SAFE_ROOM,
		"position": {"x": SAFE_POSITION.x, "y": SAFE_POSITION.y},
		"health": vitals.health,
		"mana": vitals.mana,
	}
	var file: FileAccess = FileAccess.open(save_path, FileAccess.WRITE)
	if file == null:
		push_warning("Não foi possível abrir o arquivo de salvamento: " + error_string(FileAccess.get_open_error()))
		return false
	file.store_string(JSON.stringify(data))
	file.flush()
	var result: Error = file.get_error()
	file.close()
	if result != OK:
		push_warning("Não foi possível concluir o salvamento: " + error_string(result))
		return false
	return true


func load_game(max_health: int, max_mana: int) -> Dictionary:
	if not FileAccess.file_exists(save_path):
		return {}
	var file: FileAccess = FileAccess.open(save_path, FileAccess.READ)
	if file == null:
		push_warning("Não foi possível ler o salvamento.")
		return {}
	var json: JSON = JSON.new()
	if json.parse(file.get_as_text()) != OK:
		push_warning("Salvamento inválido: JSON incorreto. Iniciando sem carregar.")
		return {}
	var data: Variant = json.data
	if not data is Dictionary or data.get("room") != SAFE_ROOM:
		push_warning("Salvamento inválido: sala desconhecida. Iniciando sem carregar.")
		return {}
	if not _valid_integer(data.get("version"), SAVE_VERSION, SAVE_VERSION):
		push_warning("Versão de salvamento incompatível. Iniciando sem carregar.")
		return {}
	var position: Variant = data.get("position")
	if not position is Dictionary or position.get("x") != SAFE_POSITION.x or position.get("y") != SAFE_POSITION.y:
		push_warning("Salvamento inválido: ponto de retorno inseguro. Iniciando sem carregar.")
		return {}
	if not _valid_integer(data.get("health"), 0, max_health) or not _valid_integer(data.get("mana"), 0, max_mana):
		push_warning("Salvamento inválido: HP/MP fora dos limites. Iniciando sem carregar.")
		return {}
	return {"position": SAFE_POSITION, "health": int(data["health"]), "mana": int(data["mana"])}


func _valid_integer(value: Variant, minimum: int, maximum: int) -> bool:
	if typeof(value) != TYPE_INT and typeof(value) != TYPE_FLOAT:
		return false
	var number: float = float(value)
	return is_finite(number) and number == floorf(number) and number >= minimum and number <= maximum
