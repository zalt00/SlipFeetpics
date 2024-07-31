extends Control

@onready var main_menu = $Main
@onready var levels_menu = $Levels
@onready var button_container = $Levels/VBoxContainer  # Assurez-vous d'avoir un conteneur pour les boutons

var scenes_path = "res://scenes/levels/"
var button_pck = preload("res://scenes/level_button.tscn")

func _ready():
	var array = get_scene_files(scenes_path)
	
	for level_path in array:
		var button = button_pck.instantiate()
		button.set_meta("scene_path", level_path)
		button.connect("pressed", Callable(self, "_on_button_pressed").bind(level_path))
		button.something = level_path
		button_container.add_child(button)
		
func get_scene_files(path):
	var dir = DirAccess.open(path)
	var scenes_array = []
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir() and file_name.ends_with(".tscn"):
				scenes_array.append(path + file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("Impossible d'ouvrir le dossier: %s" % path)
		
	return scenes_array

func _on_play_pressed():
	main_menu.hide()
	levels_menu.show()

func _on_options_pressed():
	get_tree().change_scene_to_file("res://scenes/options_menu.tscn")

func _on_quit_pressed():
	get_tree().quit()
