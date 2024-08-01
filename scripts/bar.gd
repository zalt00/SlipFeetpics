class_name HUDBar extends TextureRect

@export var textures: Array[CompressedTexture2D]


func change_fill_level(level):
	texture = textures[level]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
