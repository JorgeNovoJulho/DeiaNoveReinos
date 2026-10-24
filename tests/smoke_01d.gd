extends SceneTree
## Teste de HP/MP, dano de contato único, HUD e persistência entre salas.


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var level: Node2D = load("res://scenes/main/main.tscn").instantiate()
	level.load_on_start = false
	root.add_child(level)
	var deia: CharacterBody2D = level.get_node("Deia")
	var vitals: Node = deia.get_node("Vitals")
	var hud: CanvasLayer = level.get_node("GameHUD")
	for frame in 5:
		await physics_frame
	if vitals.health != 5 or vitals.mana != 3 or hud.get_node("Margin/VBox/HP").text != "HP: 5 / 5":
		_fail("Valores iniciais ou indicador de HP incorretos.")
		return

	deia.global_position = Vector2(760, 644)
	for frame in 20:
		await physics_frame
	if vitals.health != 4 or hud.get_node("Margin/VBox/HP").text != "HP: 4 / 5":
		_fail("O contato prolongado deve causar exatamente um dano e atualizar o HUD.")
		return

	deia.global_position = Vector2(650, 644)
	for frame in 5:
		await physics_frame
	deia.global_position = Vector2(760, 644)
	for frame in 5:
		await physics_frame
	if vitals.health != 3:
		_fail("Novo contato deve causar um novo dano.")
		return

	vitals.take_damage(100)
	vitals.restore_health(100)
	if vitals.health != 5:
		_fail("HP não foi limitado entre zero e o máximo.")
		return
	if not vitals.spend_mana(2) or vitals.spend_mana(2):
		_fail("Gasto de MP não respeitou o saldo.")
		return
	if vitals.mana != 1 or hud.get_node("Margin/VBox/MP").text != "MP: 1 / 3":
		_fail("Indicador de MP não foi atualizado.")
		return
	vitals.restore_mana(100)
	if vitals.mana != 3:
		_fail("MP ultrapassou o limite máximo.")
		return

	vitals.take_damage(2)
	deia.global_position = Vector2(1180, 644)
	for frame in 10:
		await physics_frame
	if level.get_node("RoomContainer").get_child(0).name != "TestRoom02" or vitals.health != 3:
		_fail("Transição de sala perdeu o estado de HP da personagem.")
		return

	print("FASE 01D: HP/MP, contato, HUD, limites e transição OK")
	quit(0)


func _fail(message: String) -> void:
	push_error(message)
	quit(1)
