extends Label

var start_time: float
var pause_duration: float
var paused := false
var pause_start : float
var current_time : float

func _ready() -> void:
	start_time = Time.get_ticks_msec() 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		paused = not paused
		if paused:
			pause_start = Time.get_ticks_msec()
		else:
			pause_duration += Time.get_ticks_msec() - pause_start
	current_time = Time.get_ticks_msec() - start_time - pause_duration
	text = str(floor(current_time / 10.) / 100.)
