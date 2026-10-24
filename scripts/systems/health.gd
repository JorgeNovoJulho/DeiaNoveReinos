extends Node
## Valores provisórios de vida e mana da personagem; sem progressão nesta etapa.

signal health_changed(current: int, maximum: int)
signal mana_changed(current: int, maximum: int)

@export_range(1, 999) var max_health: int = 5
@export_range(0, 999) var max_mana: int = 3

var health: int
var mana: int


func _ready() -> void:
	health = max_health
	mana = max_mana
	health_changed.emit(health, max_health)
	mana_changed.emit(mana, max_mana)


func take_damage(amount: int) -> void:
	if amount <= 0 or health <= 0:
		return
	health = maxi(health - amount, 0)
	health_changed.emit(health, max_health)


func restore_health(amount: int) -> void:
	if amount <= 0:
		return
	health = mini(health + amount, max_health)
	health_changed.emit(health, max_health)


func spend_mana(amount: int) -> bool:
	if amount < 0 or mana < amount:
		return false
	mana -= amount
	mana_changed.emit(mana, max_mana)
	return true


func restore_mana(amount: int) -> void:
	if amount <= 0:
		return
	mana = mini(mana + amount, max_mana)
	mana_changed.emit(mana, max_mana)


func set_values(saved_health: int, saved_mana: int) -> void:
	health = clampi(saved_health, 0, max_health)
	mana = clampi(saved_mana, 0, max_mana)
	health_changed.emit(health, max_health)
	mana_changed.emit(mana, max_mana)
