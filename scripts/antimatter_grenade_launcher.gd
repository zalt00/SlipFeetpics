extends Node3D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("tirer_secondaire"):
		print("grenade!")
