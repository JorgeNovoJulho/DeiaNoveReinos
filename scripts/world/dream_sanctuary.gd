class_name DreamSanctuary
extends Area2D
## Marco de descanso provisório. Sonhos e respawn de inimigos ficam para outra fase.

signal rest_requested

var _player_near: bool = false


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _process(_delta: float) -> void:
	if _player_near and Input.is_action_just_pressed("interact"):
		rest_requested.emit()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_near = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_near = false
