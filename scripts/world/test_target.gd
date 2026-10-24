extends Area2D
## Obstáculo provisório: um dano por entrada na área, sem sistema de combate.

@export_range(1, 99) var contact_damage: int = 1


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	var vitals: Node = body.get_node_or_null("Vitals")
	if vitals != null:
		vitals.take_damage(contact_damage)
