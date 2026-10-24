extends SceneTree
## Verifica ida e volta entre as duas salas sem recriar Déia.


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var level: Node2D = load("res://scenes/main/main.tscn").instantiate()
	level.load_on_start = false
	root.add_child(level)
	var deia: CharacterBody2D = level.get_node("Deia")
	var rooms: Node2D = level.get_node("RoomContainer")
	if not deia.is_in_group("player"):
		_fail("Déia não está no grupo player.")
		return
	if rooms.get_child_count() != 1 or rooms.get_child(0).name != "TestRoom01":
		_fail("Sala inicial incorreta.")
		return

	for frame in 5:
		await physics_frame
	deia.global_position = Vector2(1180, 644)
	for frame in 10:
		await physics_frame
	if rooms.get_child_count() != 1 or rooms.get_child(0).name != "TestRoom02":
		_fail("A passagem de ida não carregou a segunda sala.")
		return
	if deia != level.get_node("Deia") or absf(deia.global_position.x - 220.0) > 10.0:
		_fail("Déia não foi preservada ou entrou no local errado na sala 2.")
		return

	deia.global_position = Vector2(100, 644)
	for frame in 10:
		await physics_frame
	if rooms.get_child_count() != 1 or rooms.get_child(0).name != "TestRoom01":
		_fail("A passagem de volta não carregou a primeira sala.")
		return
	if deia != level.get_node("Deia") or absf(deia.global_position.x - 1030.0) > 10.0:
		_fail("Déia não foi preservada ou entrou no local errado na sala 1.")
		return

	var start_x: float = deia.global_position.x
	Input.action_press("move_left")
	for frame in 10:
		await physics_frame
	Input.action_release("move_left")
	if deia.global_position.x >= start_x - 20.0:
		_fail("Controle de Déia não responde após a transição.")
		return

	print("FASE 01C: ida, volta, entradas e controle preservado OK")
	quit(0)


func _fail(message: String) -> void:
	push_error(message)
	Input.action_release("move_left")
	quit(1)
