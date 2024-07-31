extends Node3D


@onready var mat_off = load("res://materials/wire_off.tres")
@onready var mat_on = load("res://materials/wire_on.tres")

var on = false :
	set(value):
		$base/bulb/spot.visible = value
		
		if value:
			$base/bulb.set_surface_override_material(0, mat_on)
		else:
			$base/bulb.set_surface_override_material(0, mat_off)
