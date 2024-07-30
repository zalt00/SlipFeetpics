extends Node3D

var sensitivity: float = 0.25
const SPEED = 3.0
const JUMP_VELOCITY = 7.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var _mouse_position = Vector2(0.0, 0.0)
var _total_pitch = 0.0

var _total_yaw = 0.0

var yaw = 0.0
var pitch = 0.0

const ACCEL = 30.0

var dt = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func is_on_floor():
	var node = get_node("ball")
	for b in node.get_colliding_bodies():
		print(4)
		if b.position.y < node.position.y:
			return true


func _update_movement(delta):
	if is_on_floor():
		print(delta)
	
	var input_dir = Input.get_vector("gauche", "droite", "avant", "arrière")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var node : RigidBody3D = get_node("ball")
	if direction:
		node.angular_damp = 0.8
		node.apply_central_force((direction * 5.0).rotated(Vector3(0, 1, 0), deg_to_rad(-_total_yaw)))
	else:
		node.angular_damp = 5.0
		
		
func _physics_process(delta):

	_mouse_position *= sensitivity
	yaw = _mouse_position.x
	pitch = _mouse_position.y
	_mouse_position = Vector2(0, 0)
	_update_movement(delta)
	# Prevents looking up/down too far
	pitch = clamp(pitch, -90 - _total_pitch, 90 - _total_pitch)
	_total_pitch += pitch
	_total_yaw += yaw
	var cam = get_node("camera_helper")
	var ball_node = get_node("ball")

	cam.rotate_object_local(Vector3(1,0,0), deg_to_rad(-pitch))
	

	cam.position = ball_node.position
	ball_node.rotate_y(deg_to_rad(-yaw))
	cam.rotate_y(deg_to_rad(-yaw))

func _input(event):
	# Receives mouse motion
	if event is InputEventMouseMotion:
		_mouse_position = event.relative

