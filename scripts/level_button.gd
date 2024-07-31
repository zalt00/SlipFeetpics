extends Button

var something

func set_something(value):
	something = value

func _on_button_up():
	get_tree().change_scene_to_file(something)
