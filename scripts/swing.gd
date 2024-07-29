extends SpotLight3D

var animation_speed : float = 1.0
var time : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	rotation = Vector3(PI/6*sin(time*animation_speed)-PI/2, 2.8059, -1.297335)
