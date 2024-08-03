extends Control

@onready var item_list: ItemList = $ItemList


var action_list = ["avant", "arrière", "gauche",
 "droite", "sauter", "respawn"]


var changing = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	InputMap.load_from_project_settings()

func _input(event):
	if event.is_action_type() and event.is_pressed():
		if changing > 0:
			InputMap.action_erase_events(action_list[changing])
			InputMap.action_add_event(action_list[changing], event)
		
		
		cancel_cur_change()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	pass # Replace with function body.

func cancel_cur_change():
	if changing > 0:
		item_list.set_item_text(changing * 2 + 1, 
		InputMap.action_get_events(action_list[changing])[0].as_text())


func _on_item_list_item_activated(index):
	cancel_cur_change()
	print(action_list[index / 2])
	var ai = index / 2
	item_list.set_item_text(ai * 2 + 1, "")
	changing = ai

