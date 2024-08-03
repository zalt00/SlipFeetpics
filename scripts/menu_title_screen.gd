extends Control

func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(preload("res://scenes/level_wall_jump.tscn"))

func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()
