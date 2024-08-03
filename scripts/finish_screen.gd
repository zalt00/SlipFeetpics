extends Control

var lvl_id = -1

var time_text : String :
	set(value):
		$MarginContainer/VBoxContainer/Time.text = value

var rank_text : String :
	set(value):
		$MarginContainer/VBoxContainer/Rank.text = value

func _on_retry_pressed():
	PlayerPositionSingleton.paused = false
	PlayerPositionSingleton.player_position = Vector3.INF
	PlayerPositionSingleton.level_ended = false
	get_tree().reload_current_scene()


func _on_main_menu_pressed():
	PlayerPositionSingleton.paused = false
	PlayerPositionSingleton.level_ended = false
	PlayerPositionSingleton.player_position = Vector3.INF
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")




func _on_next_level_pressed():
	PlayerPositionSingleton.paused = false
	PlayerPositionSingleton.player_position = Vector3.INF
	PlayerPositionSingleton.level_ended = false
	var lvl_lst = PlayerPositionSingleton.main_level_list
	if lvl_id >= lvl_lst.length():
		pass
	else:
		var new_lvl = PlayerPositionSingleton.main_level_list[lvl_id+1]
		get_tree().change_scene_to_file(new_lvl)
