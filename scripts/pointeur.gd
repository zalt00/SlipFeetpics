extends RayCast3D

var is_looking_at_interactable : bool = false
var interactable_object : Node = null

var reticule

func _process(delta):
	if is_colliding():
		var collider = get_collider()
		if collider.is_in_group("interactables"):
			is_looking_at_interactable = true
			interactable_object = collider
		else:
			is_looking_at_interactable = false
			interactable_object = null
	else:
		is_looking_at_interactable = false
		interactable_object = null
	
	if Input.is_action_pressed("interact"):
		reticule.show()
	else:
		reticule.hide()
	
	if is_looking_at_interactable and Input.is_action_just_released("interact"):
		interactable_object.call("interact")
