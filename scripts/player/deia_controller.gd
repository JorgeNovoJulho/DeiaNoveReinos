extends CharacterBody2D
## Movimento inicial de Déia: andar e saltar sobre superfícies sólidas.

@export var move_speed: float = 320.0
@export var jump_speed: float = 700.0
@export var gravity: float = 980.0


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = -jump_speed

	velocity.x = Input.get_axis("move_left", "move_right") * move_speed
	move_and_slide()
