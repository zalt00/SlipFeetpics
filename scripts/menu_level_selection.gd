extends Control

const MENU_BUTTON = preload("res://scenes/level_selection_button.tscn")

@onready var v_box_container: VBoxContainer = $MarginContainer/VBoxContainer

@export var levels: Array[PackedScene]

func _ready() -> void:
	var index = 1
	for level_cur in levels:
		var button := MENU_BUTTON.instantiate()
		v_box_container.add_child(button)
		button.text = "Level " + str(index)
		button.level = level_cur
		index += 1
