extends SceneTree
## Teste automático mínimo da Fase 01B. Executar com Godot --headless --script.


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	for action in ["move_left", "move_right", "jump"]:
		if not InputMap.has_action(action) or InputMap.action_get_events(action).is_empty():
			_fail("Ação de entrada ausente ou sem tecla: " + action)
			return

	var scene: PackedScene = load("res://scenes/main/main.tscn")
	if scene == null:
		_fail("Cena principal não foi carregada.")
		return

	var level: Node2D = scene.instantiate()
	level.load_on_start = false
	root.add_child(level)
	var deia: CharacterBody2D = level.get_node("Deia")
	var camera: Camera2D = deia.get_node("Camera2D")
	for frame in 5:
		await physics_frame
	if not deia.is_on_floor():
		_fail("Déia não está apoiada no piso inicial.")
		return

	var start_x: float = deia.global_position.x
	Input.action_press("move_right")
	for frame in 12:
		await physics_frame
	Input.action_release("move_right")
	if deia.global_position.x <= start_x + 20.0:
		_fail("Déia não se moveu para a direita.")
		return

	Input.action_press("move_left")
	for frame in 12:
		await physics_frame
	Input.action_release("move_left")
	if deia.global_position.x >= start_x + 10.0:
		_fail("Déia não se moveu para a esquerda.")
		return

	var floor_y: float = deia.global_position.y
	Input.action_press("jump")
	await physics_frame
	Input.action_release("jump")
	for frame in 15:
		await physics_frame
	if deia.global_position.y >= floor_y - 80.0:
		_fail("O salto não elevou Déia.")
		return
	if camera.global_position.y >= floor_y - 80.0:
		_fail("A câmera não acompanha a altura de Déia.")
		return

	for frame in 100:
		await physics_frame
	if not deia.is_on_floor() or absf(deia.global_position.y - floor_y) > 2.0:
		_fail("Gravidade/colisão não trouxeram Déia de volta ao piso.")
		return

	deia.global_position = Vector2(420, 400)
	deia.velocity = Vector2.ZERO
	for frame in 60:
		await physics_frame
	if not deia.is_on_floor() or absf(deia.global_position.y - 450.0) > 2.0:
		_fail("Déia não pousou na primeira plataforma elevada.")
		return

	deia.global_position = Vector2(60, floor_y)
	deia.velocity = Vector2.ZERO
	Input.action_press("move_left")
	for frame in 30:
		await physics_frame
	Input.action_release("move_left")
	if deia.global_position.x < 33.0:
		_fail("Déia atravessou a parede esquerda.")
		return

	print("FASE 01B: movimento, salto, gravidade, piso, plataforma, parede e câmera OK")
	quit(0)


func _fail(message: String) -> void:
	push_error(message)
	Input.action_release("move_right")
	Input.action_release("move_left")
	Input.action_release("jump")
	quit(1)
