extends CharacterBody3D

var sensitivity: float = 0.25
var SPEED = 5.0
const JUMP_VELOCITY = 7.0

@export var MAX_SPEED = 30.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var _mouse_position = Vector2(0.0, 0.0)
var _total_pitch = 0.0

@onready var last_checkpoint_pos: Vector3 = global_position
@onready var last_checkpoint_rotation: Vector3 = global_rotation

@onready var sub_viewport := $SubViewport
@onready var light_detection := $SubViewport/light_detection

@onready var progress_bar := $HUD/IlluminationLevel
@onready var health_bar = $HUD/BarHealth
@onready var antimatter_shotgun := $cam_helper/Camera3D/AntimatterPlayer
@onready var antimatter_grenade_launcher: Node3D = $cam_helper/AntimatterGrenadeLauncher

@onready var cam = $cam_helper
@onready var interact_raycast = $cam_helper/Camera3D/camera_items/InteractRay
@onready var aim_raycast = $cam_helper/Camera3D/camera_items/AimRay
@onready var interact_text = $UI
@onready var echap = $Echap

@onready var ammo_label = $HUD/AmmoLabel

@onready var jump_bar = $HUD/jump_bar

@onready var speed_meter_label = $HUD/speed_meter

@onready var reticule = $HUD/Reticle
@onready var camera_items = $cam_helper/Camera3D/camera_items/InteractRay

@export var breakable: CSGCombiner3D
@export var unbreakable: CSGCombiner3D
@export var health = 100

@export var number_of_shots = 5

# The minimum light level for the player to be considered in the light.
@export var light_threshold = .5

@export var run_speed_light = 5.
@export var run_speed_shadow = 10.

@export var kill_plane_y = -50.0

@export var palliers = [0.2, 0.4, 0.6, 0.8, 1.0]
@export var jump_speed = [1.0, 5.0, 7.0, 10.0, 20.0]
@export var move_speed = [20.0, 8.0, 5.0, 3.0, 1.0]

@export var friction_air := .7
@export var friction_ground := 2.

@export var gravity_multiplier := 1.

const ACCEL = 30.0

var saved_position = [Vector3(0, 0, 0)]

var dt = 0.0

var illum_level = 0.0

func set_number_of_shots(n):
	if n == -1:
		antimatter_shotgun.number_of_shots = number_of_shots
	else:
		antimatter_shotgun.number_of_shots = n

func _ready():
	floor_max_angle = deg_to_rad(60.0)
	floor_constant_speed = false
	
	floor_snap_length = 0.2

	var pos = PlayerPositionSingleton.player_position
	if pos != Vector3.INF:
		global_position = pos
		global_rotation = PlayerPositionSingleton.player_rotation
		last_checkpoint_pos = pos
		last_checkpoint_rotation = PlayerPositionSingleton.player_rotation
	
	sub_viewport.debug_draw = 2
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	antimatter_shotgun.breakable = breakable
	antimatter_shotgun.unbreakable = unbreakable
	health_bar.value = health
	antimatter_grenade_launcher.breakable = breakable
	
	antimatter_shotgun.number_of_shots = number_of_shots
	
	camera_items.reticule = reticule

func _update_movement(delta):
	if not is_on_floor():
		var multiplier = 1.0 if velocity.y > 0 else 1.8
		
		velocity.y -= gravity * delta * multiplier * gravity_multiplier # * (1.0 - illum_level) * 1.6
	
	
	
	
	var pallier = 0
	while illum_level > palliers[pallier]:
		pallier += 1

	$HUD/jump_bar.change_fill_level(pallier)
	$HUD/pallier_label.text = str(pallier)
	
	var new_speed = move_speed[pallier]
	if is_on_floor():
		if new_speed < SPEED:
			SPEED = move_toward(SPEED, new_speed, 10. * delta)
		else:
			SPEED = new_speed
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and dt < 0.4:
		var jump_velo = jump_speed[pallier]
		
		velocity.y = jump_velo
		dt = 999999.0
		$sounds.pitch_scale = 2 - illum_level
		$sounds.play()
		
	if Input.is_action_just_pressed("godmod"):
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("gauche", "droite", "avant", "arrière")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var multiplier = friction_ground if is_on_floor() else friction_air
	
	var plan_velo = Vector2(velocity.x, velocity.z)
	var plan_speed = plan_velo.length()

	var dontcorrect = false
	
	var norm = velocity.normalized()
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, ACCEL * delta * abs(norm.x))
		velocity.z = move_toward(velocity.z, 0, ACCEL * delta * abs(norm.z))
	
	if direction:

		velocity.x += multiplier * ACCEL * delta*direction.x
		velocity.z += multiplier * ACCEL * delta*direction.z
		var plan_speed2 = Vector2(velocity.x, velocity.z).length()
		if plan_speed2 >= SPEED && plan_speed2 >= plan_speed:
			velocity.x = velocity.x * plan_speed / plan_speed2
			velocity.z = velocity.z * plan_speed / plan_speed2
			if is_on_floor():
				velocity *= 0.997
		else:
			dontcorrect = true
	
	var plan_speed3 = Vector2(velocity.x, velocity.z).length()
	if (plan_speed3 < SPEED and SPEED - 0.8 < plan_speed3 and direction 
		and not dontcorrect):
		velocity.x = velocity.x * SPEED / plan_speed3
		velocity.z = velocity.z * SPEED / plan_speed3
		
	speed_meter_label.text = str(snapped(Vector2(velocity.x, velocity.z).length(), 0.1))
	#if plan_speed > SPEED:
		#velocity.x = velocity.x * SPEED / plan_speed
		#velocity.z = velocity.z * SPEED / plan_speed
	var speed = velocity.length()
	if speed > MAX_SPEED:
		velocity = velocity / speed * MAX_SPEED
	
	ammo_label.text = str(antimatter_shotgun.number_of_shots)
	
	
func _physics_process(delta):
	if is_on_floor():
		dt = 0.0
		saved_position.append(position)
		if len(saved_position) > 10:
			saved_position.pop_front()
	else:
		dt += delta
		if position.y < kill_plane_y:
			position = saved_position[0]
			velocity = Vector3(0, 0, 0)
	
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
		
	if Input.is_action_just_pressed("respawn"):

		PlayerPositionSingleton.player_position = last_checkpoint_pos
		PlayerPositionSingleton.player_rotation = last_checkpoint_rotation
		get_tree().reload_current_scene()
		
	if interact_raycast.is_looking_at_interactable:
		interact_text.show()
	else:
		interact_text.hide()

func _on_modify_health_pressed(attack = 10):
	health += attack
	health_bar.value = health
