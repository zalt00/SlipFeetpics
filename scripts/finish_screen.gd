extends Control

var time_text : String :
	set(value):
		$MarginContainer/VBoxContainer/Time.text = value

var rank_text : String :
	set(value):
		$MarginContainer/VBoxContainer/Rank.text = value

func _on_retry_pressed():
	PlayerPositionSingleton.paused = false
	get_tree().reload_current_scene()


func _on_main_menu_pressed():
	PlayerPositionSingleton.paused = false

	get_tree().change_scene_to_file("res://scenes/Menu.tscn")


