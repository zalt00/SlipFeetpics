extends Control

@onready var item_list: ItemList = $ItemList


var action_list = ["avant", "arrière", "gauche",
 "droite", "sauter", "respawn"]


var changing = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	InputMap.load_from_project_settings()
	
	for i in range(len(action_list)):
		changing = i
		cancel_cur_change()
	changing = -1

func _input(event):
	
	if event.is_action_type() and event.is_pressed() and not event.as_text().contains("Left Mouse Button"):
		print("welp")
		if changing >= 0:
			InputMap.action_erase_events(action_list[changing])
			InputMap.action_add_event(action_list[changing], event)
		
		cancel_cur_change()
		changing = -1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func cancel_cur_change():
	if changing >= 0:
		item_list.set_item_text(changing * 2 + 1, 
		InputMap.action_get_events(action_list[changing])[0].as_text())
		
		
		
func save():
	var i = 0
	for action in action_list:
		ProjectSettings.set_setting("input/"+action,
		 {"deadzone": 0.5, "events": InputMap.action_get_events(action_list[i])})
		i += 1
		
	ProjectSettings.save()




func _on_item_list_item_clicked(index, at_position, mouse_button_index):
	cancel_cur_change()
	print(action_list[index / 2])
	var ai = index / 2
	item_list.set_item_text(ai * 2 + 1, "")
	changing = ai


func _on_apply_pressed():
	save()


func _on_cancel_pressed():
	InputMap.load_from_project_settings()
	for i in range(len(action_list)):
		changing = i
		cancel_cur_change()
	changing = -1


func _on_button_pressed():
	var menu = preload("res://scenes/menu_title_screen.tscn").instantiate()
	get_tree().current_scene.add_child(menu)
	queue_free()
