extends Control

func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(preload("res://scenes/level_wall_jump.tscn"))

func _on_options_pressed() -> void:
	pass

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_level_select_pressed() -> void:
	var menu = preload("res://scenes/menu_level_selection.tscn").instantiate()
	get_tree().current_scene.add_child(menu)
	queue_free()
