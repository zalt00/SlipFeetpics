extends StaticBody3D

@onready var press_area = $CollisionShape3D/press_area

@onready var mat_off = load("res://materials/wire_off.tres")
@onready var mat_on = load("res://materials/wire_on.tres")

@export var powered : Array[Node3D]

var pressing = false
var animation_speed = 0.2
var pressed = false :
	set(value):
		for child in powered:
			child.on = value
			

@onready var mat1 = $CollisionShape3D2/light1.get_surface_override_material(0)
@onready var mat2 = $CollisionShape3D2/light2.get_surface_override_material(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if pressing && not pressed: 
		if $button.position[1] > 0.2:
			$button.translate(Vector3(0.0, -animation_speed*delta, 0.0))
		else:
			pressed = true
			$CollisionShape3D2/light1.set_surface_override_material(0, mat_on)
			$CollisionShape3D2/light2.set_surface_override_material(0, mat_on)
			
	elif $button.position[1] < 0.25 && not pressing:
		pressed = false
		$button.translate(Vector3(0.0, animation_speed*delta, 0.0))
		$CollisionShape3D2/light1.set_surface_override_material(0, mat_off)
		$CollisionShape3D2/light2.set_surface_override_material(0, mat_off)
	
	
func _on_press_area_body_entered(body):
	if not body.is_in_group("switch"):
		pressing = true


func _on_press_area_body_exited(body):
	pressing = false
