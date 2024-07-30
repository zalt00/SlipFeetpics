extends Label

var start_time: float

func _ready() -> void:
	start_time = Time.get_ticks_msec()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var current_time := Time.get_ticks_msec() - start_time
	text = str(current_time)
