extends StaticBody3D

@export var lights : Node3D
@export var pressed = false

var pressing = false

@onready var mat_off = load("res://materials/wire_off.tres")
@onready var mat_on = load("res://materials/wire_on.tres")
@onready var lever = $Lever

var animation_speed = 3

func _ready():
	for light in lights.get_children():
		var bulb = light.get_node("bulb")
		var spot = light.get_node("spot")
		if spot:
			spot.visible = pressed
		if bulb:
			if pressed:
				bulb.material_override = mat_on
			else:
				bulb.material_override = mat_off
	pressing = !pressing

func interact():
	for light in lights.get_children():
		var bulb = light.get_node("bulb")
		var spot = light.get_node("spot")
		if spot:
			spot.visible = !spot.visible
		if bulb:
			if pressed:
				bulb.material_override = mat_on
			else:
				bulb.material_override = mat_off
	pressing = !pressing

func _process(delta):
	
	if pressing:
		if not pressed:
			if lever.rotation_degrees.x < 135:
				lever.rotate_x(animation_speed * delta)
			else:
				pressed = true
				lever.rotation_degrees.x = 135
				pressing = false
		else:
			if lever.rotation_degrees.x > 45:
				lever.rotate_x(-animation_speed * delta)
			else:
				pressed = false
				lever.rotation_degrees.x = 45
				pressing = false
		
	else:
		if pressed:
			lever.rotation_degrees.x = 135
		else:
			lever.rotation_degrees.x = 45
