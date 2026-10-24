class_name RoomExit
extends Area2D
## Passagem de teste: identifica uma sala e o ponto de chegada correspondente.

signal transition_requested(scene_path: String, entry_name: StringName)

@export_file("*.tscn") var destination_scene: String
@export var destination_entry: StringName


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not destination_scene.is_empty():
		transition_requested.emit(destination_scene, destination_entry)
