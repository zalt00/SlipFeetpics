extends AnimatableBody3D

@export var player: CharacterBody3D

var move = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if move and position.z > -30 and not PlayerPositionSingleton.paused:
		position.z += -delta*10.0
		


func _on_area_3d_body_entered(body):
	if body == player:
		move = true
