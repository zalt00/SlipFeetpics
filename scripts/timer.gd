extends Node

var start_time: float
var pause_duration: float
var paused := false
var pause_start : float
var current_time : float

@export var player : CharacterBody3D


func _ready() -> void:
	start_time = Time.get_ticks_msec() 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.echap.pause:
		if not paused:
			pause_start = Time.get_ticks_msec()
			paused = true
	elif paused:
		pause_duration += Time.get_ticks_msec() - pause_start
		paused = false
	else:
		current_time = Time.get_ticks_msec() - start_time - pause_duration
	$Label.text = "TIME : " + str(floor(current_time / 10.) / 100.)
