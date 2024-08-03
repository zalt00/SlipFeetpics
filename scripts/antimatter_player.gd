extends Node3D

# Modifier keys' speed multiplier

var breakable: CSGCombiner3D
var unbreakable: CSGCombiner3D
@export var projectile: Node3D

var number_of_shots

var last_shot = 0

@onready var previsu_meshi := $Previsu
@onready var unbreakable_normal = preload("res://materials/unbreakable.tres")
@onready var unbreakable_colored = preload("res://materials/unbreakable_colored.tres")

@onready var quoiquoushader := $"quad de shader2"
var copies = []

func _ready():
	previsu_meshi.hide()

func clear_antimater():
	for obj in copies:
		obj.queue_free()
	copies.clear()

		
func _input(event):
	if not PlayerPositionSingleton.paused:
		if Input.is_action_pressed("viser"):
			previsu_meshi.show()
			update_materials(unbreakable_colored)
		elif Input.is_action_just_released("viser"):
			previsu_meshi.hide()
			update_materials(unbreakable_normal)
		
		var time = Time.get_ticks_msec()
		
		if Input.is_action_just_pressed("tirer") && number_of_shots > 0 && time - last_shot > 50:
			PlayerPositionSingleton.resume()
			var copy: Node3D = projectile.duplicate()
			add_child(copy)
			copy.visible = true
			copy.reparent(breakable, true)
			copies.append(copy)
			
			if len(copies) > 10:
				var obj = copies.pop_front()
				obj.queue_free()
				
			number_of_shots -= 1
			last_shot = time
	else:
		previsu_meshi.hide()
		update_materials(unbreakable_normal)
		
func update_materials(material):
	if unbreakable:
		unbreakable.material_override = material
