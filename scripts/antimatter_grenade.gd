extends RigidBody3D

@export var timer: Timer
@export var explosion: CSGBox3D

var breakable: CSGCombiner3D

func _ready() -> void:
	timer.start()

func _on_timer_timeout() -> void:
	explosion.visible = true
	explosion.reparent(breakable)
	explosion.rotation = Vector3(0., 0., 0.)
	queue_free()
