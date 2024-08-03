extends Control

const MENU_BUTTON = preload("res://scenes/level_selection_button.tscn")

@onready var v_box_container: VBoxContainer = $MarginContainer/VBoxContainer

@export var levels: Array[PackedScene]
@export var bonus_levels: Array[PackedScene]

func _ready() -> void:
	var index = 1
	for level_cur in levels:
		var button := MENU_BUTTON.instantiate()
		v_box_container.add_child(button)
		button.text = "Level " + str(index)
		button.level = level_cur
		index += 1

func _on_menu_button_pressed() -> void:
	var menu = load("res://scenes/menu_title_screen.tscn").instantiate()
	get_tree().current_scene.add_child(menu)
	queue_free()