extends Node3D

# Modifier keys' speed multiplier

var breakable: CSGCombiner3D
@export var projectile: Node3D

@onready var previsu_meshi := $Previsu

var copies = []

func _ready():
	pass


func _input(event):
	pass

# Updates mouselook and movement every frame
func _process(delta):

	if Input.is_action_just_pressed("tirer"):
		var copy: Node3D = projectile.duplicate()
		add_child(copy)
		copy.visible = true
		copy.reparent(breakable, true)
		copies.append(copy)
		
		if len(copies) > 10:
			var obj = copies.pop_front()
			obj.queue_free()
			
		print(len(copies))
	if Input.is_action_pressed("viser"):
		previsu_meshi.show()
	else:
		previsu_meshi.hide()
