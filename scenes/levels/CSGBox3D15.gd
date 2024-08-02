extends CSGBox3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


var t = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	t += delta
	position.x = sin(t / 20.0) * 50.0
