extends Timer

func _ready() -> void:
	start()

func _on_timeout() -> void:
	print("explosion!")
