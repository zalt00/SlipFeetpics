extends CharacterBody3D

var sensitivity: float = 0.25
const SPEED = 5.0
const JUMP_VELOCITY = 7.0

const MAX_SPEED = 30.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var _mouse_position = Vector2(0.0, 0.0)
var _total_pitch = 0.0

@onready var sub_viewport := $SubViewport
@onready var light_detection := $SubViewport/light_detection
@onready var texture_rect := $TextureRect
@onready var progress_bar := $HUD/IlluminationLevel
@onready var health_bar = $HUD/BarHealth
@onready var antimatter_shotgun := $cam_helper/Camera3D/AntimatterPlayer
@onready var antimatter_grenade_launcher: Node3D = $cam_helper/AntimatterGrenadeLauncher

@onready var ammo_label = $HUD/AmmoLabel

@export var breakable: CSGCombiner3D
@export var health = 100

@export var number_of_shots = 5

const ACCEL = 30.0

var dt = 0.0

var illum_level = 0.0

func set_number_of_shots(n):
	if n == -1:
		antimatter_shotgun.number_of_shots = number_of_shots
	else:
		antimatter_shotgun.number_of_shots = n

func _ready():
	sub_viewport.debug_draw = 2
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	antimatter_shotgun.breakable = breakable
	health_bar.value = health
	antimatter_grenade_launcher.breakable = breakable
	
	antimatter_shotgun.number_of_shots = number_of_shots

func _update_movement(delta):
	if not is_on_floor():
		var multiplier = 1.0 if velocity.y > 0 else 1.8
		
		velocity.y -= gravity * delta * multiplier # * (1.0 - illum_level) * 1.6

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and dt < 0.2:
		velocity.y = JUMP_VELOCITY * (illum_level + 0.6)
		dt = 999999.0
		$sounds.play()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("gauche", "droite", "avant", "arrière")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var multiplier = 2.0 if is_on_floor() else 0.7
	
	if direction:
		
		velocity.x += multiplier * ACCEL * delta*direction.x
		velocity.z += multiplier * ACCEL * delta*direction.z
		


	var norm = velocity.normalized()
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, ACCEL * delta * abs(norm.x))
		velocity.z = move_toward(velocity.z, 0, ACCEL * delta * abs(norm.z))
		
	var plan_velo = Vector2(velocity.x, velocity.z)
	var plan_speed = plan_velo.length()
	if plan_speed > SPEED:
		velocity.x = velocity.x * SPEED / plan_speed
		velocity.z = velocity.z * SPEED / plan_speed
	var speed = velocity.length()
	if speed > MAX_SPEED:
		velocity = velocity / speed * MAX_SPEED
	
	ammo_label.text = str(antimatter_shotgun.number_of_shots)
	
	
func _physics_process(delta):
	if is_on_floor():
		dt = 0.0
	else:
		dt += delta
	
	_update_movement(delta)
	# Add the gravity.
	_mouse_position *= sensitivity
	var yaw = _mouse_position.x
	var pitch = _mouse_position.y
	_mouse_position = Vector2(0, 0)
	
	# Prevents looking up/down too far
	pitch = clamp(pitch, -90 - _total_pitch, 90 - _total_pitch)
	_total_pitch += pitch

	rotate_y(deg_to_rad(-yaw))
	var cam = get_node("cam_helper")
	
	cam.rotate_object_local(Vector3(1,0,0), deg_to_rad(-pitch))

	move_and_slide()

func _process(delta):
	light_detection.global_position = global_position
	var tex : ViewportTexture = sub_viewport.get_texture()
	var img = tex.get_image()
	img.resize(1, 1, Image.INTERPOLATE_LANCZOS)
	illum_level = img.get_pixel(0, 0).r
	progress_bar.value = illum_level
	
func _input(event):
	# Receives mouse motion
	if event is InputEventMouseMotion and not $Echap.pause:
		_mouse_position = event.relative
			
func _on_modify_health_pressed(attack = 10):
	health += attack
	health_bar.value = health
