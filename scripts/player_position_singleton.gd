extends Node

var player_position = Vector3.INF
var player_rotation = Vector3.INF


var paused = false

var ellapsed = 0
var start_time = 0

var timer_paused = true

var level_ended = false

var current_music
var truc = load("res://scenes/levels/tutoriel.tscn")
var main_level_list = [
	"res://scenes/levels/tutoriel.tscn",
	"res://scenes/levels/level_carve.tscn",
	"res://scenes/level_carve_jump.tscn",
	"res://scenes/level_bounce.tscn",
	"res://scenes/level_midair_blast.tscn",
	"res://scenes/level_wall_jump.tscn",
	"res://scenes/level_platformer.tscn",
	"res://scenes/levels/level_fast.tscn",
	"res://scenes/levels/jsp.tscn"
]



func resume():
	if timer_paused:
		timer_paused = false
		start_time = Time.get_ticks_msec()

func pause():
	if not timer_paused:
		timer_paused = true
		var time = Time.get_ticks_msec()
		ellapsed += time - start_time
		start_time = time

func reset():
	pause()
	ellapsed = 0
	start_time = Time.get_ticks_msec()



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var time = Time.get_ticks_msec()
	if not PlayerPositionSingleton.timer_paused:
		PlayerPositionSingleton.ellapsed += time - PlayerPositionSingleton.start_time
	PlayerPositionSingleton.start_time = time
