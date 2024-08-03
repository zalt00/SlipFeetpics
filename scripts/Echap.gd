extends Control

@onready var principal = $Principal
@onready var options = $Options

var pause = false

func _ready():
	pause = false
	principal.hide()
	options.hide()
	process_mode = Node.PROCESS_MODE_PAUSABLE

func _on_resume_pressed():
	resume()
	PlayerPositionSingleton.resume()

func _on_options_pressed():
	principal.hide()
	options.show()

func _on_option_back_pressed():
	principal.show()
	options.hide()

func _on_menu_pressed():
	PlayerPositionSingleton.paused = false
	PlayerPositionSingleton.player_position = Vector3.INF
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
	PlayerPositionSingleton.reset()

func _on_quit_pressed():
	get_tree().quit()

func _input(event):
	if Input.is_action_just_pressed("echap"):
		if not PlayerPositionSingleton.paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			principal.show()
			PlayerPositionSingleton.paused = true
			pause = true
			#get_tree().paused = true
			PlayerPositionSingleton.pause()
		else:
			resume()
			PlayerPositionSingleton.resume()


func _on_respawn_pressed():
	resume()
	get_tree().reload_current_scene()
	
func resume():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	principal.hide()
	pause = false
	PlayerPositionSingleton.paused = false
