extends Node3D

var breakable: CSGCombiner3D

const ANTIMATTER_GRENADE := preload("res://scenes/antimatter_grenade.tscn")
const LAUNCH_SPEED := 10.

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("tirer_secondaire"):
		var grenade_instance := ANTIMATTER_GRENADE.instantiate()
		add_child(grenade_instance)
		grenade_instance.breakable = breakable
		grenade_instance.reparent(get_tree().get_root())
		grenade_instance.linear_velocity = -LAUNCH_SPEED * global_transform.basis.z
