extends Node3D

@export var player: CharacterBody3D
@export var respawn_location: Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	if body == player:
		player.last_checkpoint_pos = respawn_location.global_position
		player.last_checkpoint_rotation = respawn_location.global_rotation
