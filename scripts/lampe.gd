extends RigidBody3D

@onready var mat1 = $Manche.mesh.surface_get_material(0)
@onready var shader1 = mat1.get_next_pass()


@onready var mat2 = $Manche/Cone.mesh.surface_get_material(0)
@onready var shader2 = mat2.get_next_pass()

var targeted = false :
	set(value):
		targeted = value
		set_targeted(value)


func set_targeted(val):
	if targeted:
		shader1.set_shader_parameter("strength", 1.0)
		shader2.set_shader_parameter("strength", 1.0)
	else:
		shader1.set_shader_parameter("strength", 0.0)
		shader2.set_shader_parameter("strength", 0.0)
		
