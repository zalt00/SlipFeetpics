extends StaticBody3D

@export var lights : Array[Node3D]

var pressing = false
var pressed = false

@onready var mat_off = load("res://materials/wire_off.tres")
@onready var mat_on = load("res://materials/wire_on.tres")
@onready var lever = $Lever

var animation_speed = 3

func interact():
	for light in lights:
		var bulb = light.get_node("bulb")
		var spot = light.get_node("spot")
		if spot:
			spot.visible = !spot.visible
		if bulb:
			if spot.visible:
				bulb.set_material(mat_on)
			else:
				bulb.set_material(mat_off)
	pressing = !pressing

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if pressing and not pressed:
		if lever.rotation_degrees.x < 135:
			lever.rotate_x(animation_speed * delta)
		else:
			pressed = true
			lever.rotation_degrees.x = 135
	elif not pressing and lever.rotation_degrees.x > 0:
		lever.rotate_x(-animation_speed * delta)
		if lever.rotation_degrees.x <= 45:
			lever.rotation_degrees.x = 45
			pressed = false

