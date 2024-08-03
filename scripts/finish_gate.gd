extends Node3D


@export var player: CharacterBody3D
@export var rank_times : Array[float]

var ranks = ['C', 'B', 'A', 'S', 'I Beat The Devs']
# Called when the node enters the scene tree for the first time.
func _ready():
	$finish_screen.hide()

func _on_area_3d_body_entered(body):
	if body == player:
		PlayerPositionSingleton.level_ended = true
		var time = floor(PlayerPositionSingleton.ellapsed / 10.) / 100.
		var j = 0
		for i in range(4):
			if time < rank_times[j] :
				j = i+1
		
		$finish_screen.rank_text = "RANK : " + ranks[j]
		
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$finish_screen.time_text = str(time)
		$finish_screen.show()
		PlayerPositionSingleton.paused = true
		PlayerPositionSingleton.reset()
		player.echap.pause = true
		
