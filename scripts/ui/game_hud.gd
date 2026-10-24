extends CanvasLayer
## Indicadores fixos na tela; conectados aos sinais dos valores da personagem.

@onready var hp_label: Label = $Margin/VBox/HP
@onready var mp_label: Label = $Margin/VBox/MP


func bind(vitals: Node) -> void:
	vitals.health_changed.connect(_update_health)
	vitals.mana_changed.connect(_update_mana)
	_update_health(vitals.health, vitals.max_health)
	_update_mana(vitals.mana, vitals.max_mana)


func _update_health(current: int, maximum: int) -> void:
	hp_label.text = "HP: %d / %d" % [current, maximum]


func _update_mana(current: int, maximum: int) -> void:
	mp_label.text = "MP: %d / %d" % [current, maximum]
