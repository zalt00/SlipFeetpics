extends StaticBody3D

@onready var press_area = $CollisionShape3D/press_area

var pressing = false
var animation_speed = 0.2
var pressed = false

@onready var mat1 = $CollisionShape3D2/light1.get_surface_override_material(0)
@onready var mat2 = $CollisionShape3D2/light2.get_surface_override_material(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if pressing : 
		if $button.position[1] > 0.2:
			$button.translate(Vector3(0.0, -animation_speed*delta, 0.0))
		else:
			pressed = true
			mat1.albedo_color = Color(1.0, 0.95, 0.0, 1.0)
			mat2.albedo_color = Color(1.0, 0.95, 0.0, 1.0)
			
	elif $button.position[1] < 0.25:
		pressed = false
		$button.translate(Vector3(0.0, animation_speed*delta, 0.0))
		mat1.albedo_color = Color(1.0, 0.95, 0.0, 1.0)
		mat2.albedo_color = Color(1.0, 0.95, 0.0, 1.0)
	
	
func _on_press_area_body_entered(body):
	if not body.is_in_group("switch"):
		pressing = true


func _on_press_area_body_exited(body):
	pressing = false
