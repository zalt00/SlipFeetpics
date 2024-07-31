extends Node3D


@export var player: CharacterBody3D
@export var refill: int = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	if body == player:
		player.set_number_of_shots(refill)
		player.antimatter_shotgun.clear_antimater()
