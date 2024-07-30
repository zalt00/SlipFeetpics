extends CharacterBody3D

var sensitivity: float = 0.25
const SPEED = 5.0
const JUMP_VELOCITY = 7.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var _mouse_position = Vector2(0.0, 0.0)
var _total_pitch = 0.0


const ACCEL = 30.0
var speed = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):


	# Add the gravity.
	if not is_on_floor():
		var multiplier = 1.0 if velocity.y > 0 else 1.8
		
		velocity.y -= gravity * delta * multiplier

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("gauche", "droite", "avant", "arrière")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		
		velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCEL * delta*abs(direction.x))
		velocity.z = move_toward(velocity.z, direction.z * SPEED, ACCEL * delta*abs(direction.z))
	else:
		var norm = velocity.normalized()
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, ACCEL * delta * abs(norm.x))
			velocity.z = move_toward(velocity.z, 0, ACCEL * delta * abs(norm.z))
		
		
	_mouse_position *= sensitivity
	var yaw = _mouse_position.x
	var pitch = _mouse_position.y
	_mouse_position = Vector2(0, 0)
	
	# Prevents looking up/down too far
	pitch = clamp(pitch, -90 - _total_pitch, 90 - _total_pitch)
	_total_pitch += pitch

	rotate_y(deg_to_rad(-yaw))
	var cam = get_node("Camera3D")
	
	cam.rotate_object_local(Vector3(1,0,0), deg_to_rad(-pitch))

	move_and_slide()

func _input(event):
	# Receives mouse motion
	if event is InputEventMouseMotion:
		_mouse_position = event.relative

