extends Node3D


@export var player: CharacterBody3D
@export var timer : Node
# Called when the node enters the scene tree for the first time.
func _ready():
	$finish_screen.hide()

func _on_area_3d_body_entered(body):
	if body == player:
		var time = str(floor(timer.current_time / 10.) / 100.)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$finish_screen.time_text = time
		$finish_screen.show()
		get_tree().paused = true
		player.echap.pause = true
		
