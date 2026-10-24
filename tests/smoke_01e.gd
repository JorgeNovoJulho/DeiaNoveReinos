extends SceneTree
## Usa um arquivo de teste exclusivo em user://, sem tocar no save real.

var _test_path: String


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	_test_path = "user://smoke_01e_%d.json" % Time.get_ticks_usec()
	var scene: PackedScene = load("res://scenes/main/main.tscn")
	var level: Node2D = scene.instantiate()
	level.load_on_start = false
	level.get_node("SaveManager").save_path = _test_path
	root.add_child(level)
	var deia: CharacterBody2D = level.get_node("Deia")
	var vitals: Node = deia.get_node("Vitals")
	if not InputMap.has_action("interact"):
		_fail("Ação interagir ausente.")
		return
	for frame in 5:
		await physics_frame
	vitals.take_damage(2)
	vitals.spend_mana(1)
	deia.global_position = Vector2(520, 644)
	for frame in 5:
		await physics_frame
	Input.action_press("interact")
	for frame in 3:
		await process_frame
	Input.action_release("interact")
	if vitals.health != 5 or vitals.mana != 3 or not FileAccess.file_exists(_test_path):
		_fail("Santuário não restaurou HP/MP ou não gravou o save.")
		return

	var saved: Dictionary = level.get_node("SaveManager").load_game(5, 3)
	if saved.is_empty() or saved["position"] != Vector2(520, 644):
		_fail("Save local não contém o ponto seguro esperado.")
		return

	level.queue_free()
	await process_frame
	var reloaded: Node2D = scene.instantiate()
	reloaded.get_node("SaveManager").save_path = _test_path
	root.add_child(reloaded)
	if reloaded.get_node("Deia").global_position != Vector2(520, 644):
		_fail("Novo jogo não retomou no santuário.")
		return
	if reloaded.get_node("Deia/Vitals").health != 5 or reloaded.get_node("Deia/Vitals").mana != 3:
		_fail("Novo jogo não retomou HP/MP salvos.")
		return

	# O teste de dados inválidos não altera o save real do jogador.
	var file: FileAccess = FileAccess.open(_test_path, FileAccess.WRITE)
	file.store_string("{arquivo-invalido")
	file.close()
	if not reloaded.get_node("SaveManager").load_game(5, 3).is_empty():
		_fail("Save inválido foi aceito.")
		return

	_cleanup()
	print("FASE 01E: santuário, HP/MP, save/load e save inválido OK")
	quit(0)


func _fail(message: String) -> void:
	Input.action_release("interact")
	_cleanup()
	push_error(message)
	quit(1)


func _cleanup() -> void:
	if not _test_path.is_empty() and FileAccess.file_exists(_test_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(_test_path))
