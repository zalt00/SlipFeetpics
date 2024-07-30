extends Label

var start_time: float
var pause_duration: float
var paused := false

func _ready() -> void:
	start_time = Time.get_ticks_msec() / 1000.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		paused = not paused
	if paused:
		pause_duration += delta
	var current_time := Time.get_ticks_msec() / 1000. - start_time - pause_duration
	text = str(floor(current_time * 100.) / 100.)
