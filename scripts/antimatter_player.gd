extends Node3D

# Modifier keys' speed multiplier

var breakable: CSGCombiner3D
@export var projectile: Node3D



func _input(event):
	pass

# Updates mouselook and movement every frame
func _process(delta):

	print(breakable)
	if Input.is_action_just_pressed("tirer"):
		var copy: Node3D = projectile.duplicate()
		add_child(copy)
		copy.visible = true
		copy.reparent(breakable, true)

