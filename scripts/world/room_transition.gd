extends Node2D
## Mantém Déia e sua câmera; substitui apenas a sala ativa.

@onready var room_container: Node2D = $RoomContainer
@onready var deia: CharacterBody2D = $Deia
@onready var save_manager: Node = $SaveManager

var _transitioning: bool = false
var load_on_start: bool = true


func _ready() -> void:
	_connect_exits(room_container.get_child(0))
	$GameHUD.bind(deia.get_node("Vitals"))
	if load_on_start:
		var vitals: Node = deia.get_node("Vitals")
		var saved: Dictionary = save_manager.load_game(vitals.max_health, vitals.max_mana)
		if not saved.is_empty():
			deia.global_position = saved["position"]
			vitals.set_values(saved["health"], saved["mana"])
			deia.get_node("Camera2D").reset_smoothing()


func _connect_exits(room: Node) -> void:
	for area in room.find_children("*", "Area2D", true, false):
		if area is RoomExit:
			area.transition_requested.connect(_on_transition_requested)
		elif area is DreamSanctuary:
			area.rest_requested.connect(_on_rest_requested)


func _on_rest_requested() -> void:
	var vitals: Node = deia.get_node("Vitals")
	vitals.restore_health(vitals.max_health)
	vitals.restore_mana(vitals.max_mana)
	if not save_manager.save_game(vitals):
		push_warning("Déia descansou, mas não foi possível salvar o progresso.")


func _on_transition_requested(scene_path: String, entry_name: StringName) -> void:
	if _transitioning:
		return
	_transitioning = true
	# Não alterar corpos e áreas no meio da atualização de física.
	_change_room.call_deferred(scene_path, entry_name)


func _change_room(scene_path: String, entry_name: StringName) -> void:
	var packed_room: PackedScene = load(scene_path) as PackedScene
	if packed_room == null:
		push_error("Sala não encontrada: " + scene_path)
		_transitioning = false
		return

	var new_room: Node2D = packed_room.instantiate() as Node2D
	if new_room == null:
		push_error("Cena de sala inválida: " + scene_path)
		_transitioning = false
		return

	var entry: Marker2D = new_room.get_node_or_null(NodePath("Entries/" + String(entry_name))) as Marker2D
	if entry == null:
		push_error("Entrada não encontrada na sala: " + String(entry_name))
		new_room.queue_free()
		_transitioning = false
		return

	var old_room: Node = room_container.get_child(0)
	room_container.remove_child(old_room)
	old_room.queue_free()
	room_container.add_child(new_room)
	_connect_exits(new_room)
	deia.velocity = Vector2.ZERO
	deia.global_position = entry.global_position
	deia.get_node("Camera2D").reset_smoothing()
	_transitioning = false
