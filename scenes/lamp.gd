extends Node3D


@onready var mat_off = load("res://materials/wire_off.tres")
@onready var mat_on = load("res://materials/wire_on.tres")
@export var energy : float = 10.0

@export var already_on = false
var on = false :
	set(value):
		$base/bulb/spot.visible = value
		
		if value:
			$base/bulb.set_surface_override_material(0, mat_on)
		else:
			$base/bulb.set_surface_override_material(0, mat_off)


func _ready():
	mat_on = mat_on.duplicate()
	mat_on.emission_enabled = true
	mat_on.emission_energy_multiplier = 10
	mat_on.emission = Color(1.0, 0.95, 0.0, 1.0)
	
	on = already_on
	
	$base/bulb/spot.light_energy = energy

