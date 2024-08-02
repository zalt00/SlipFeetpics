extends Area3D

@export var player : CharacterBody3D

func _on_body_entered(body):
	if body == player:

		get_tree().reload_current_scene()
