extends Button

var level_path

func _on_button_up():
	get_tree().change_scene_to_file(level_path)
