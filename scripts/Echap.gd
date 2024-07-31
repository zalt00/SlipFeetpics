extends Control

@onready var principal = $Principal
@onready var options = $Options

var pause = false

func _ready():
	pause = false
	principal.visible = false
	options.visible = false
	process_mode = Node.PROCESS_MODE_PAUSABLE

func _on_resume_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	principal.visible = false
	pause = false

func _on_options_pressed():
	principal.visible = false
	options.visible = true

func _on_option_back_pressed():
	principal.visible = true
	options.visible = false

func _on_quit_pressed():
	get_tree().change_scene_to_file("res://scenes/scenes/Menu.tscn")
	get_tree().quit()

func _input(event):
	if Input.is_action_just_pressed("echap"):
		if not pause:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			principal.visible = true
			pause = true
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			principal.visible = false
			options.visible = false
			pause = false
