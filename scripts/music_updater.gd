extends Node

@export var music: AudioStream

func _ready() -> void:
	PlayerPositionSingleton.current_music = music
