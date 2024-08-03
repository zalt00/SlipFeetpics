extends AudioStreamPlayer

var scene_cur: Node

func _process(delta: float) -> void:
	if stream != PlayerPositionSingleton.current_music && PlayerPositionSingleton.current_music != null:
		stream = PlayerPositionSingleton.current_music
		play()
		print(stream)
