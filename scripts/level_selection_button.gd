extends Button

var level: PackedScene
var callback


func _on_pressed() -> void:
	get_tree().change_scene_to_packed(level)

