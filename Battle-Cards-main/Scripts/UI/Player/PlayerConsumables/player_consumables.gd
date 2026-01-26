extends Node2D

const CONSUMABLE_X_POSITION = -100
const CONSUMABLE_Y_POSITION = -60
const CONSUMABLE_Y_HORIZONTAL_POSITION = 950


func _ready():
	set_consumables()

func set_consumables():
	var player_consumables = Global.player_consumables

	for i in player_consumables:
		var new_instance = load(i.consumable_scene_path).instantiate()
		new_instance.consumable_stats = i
		add_child(new_instance)
		new_instance.get_node("BaseConsumable").update_stack_ui()
		new_instance.get_node("BaseConsumable").toggle_info_ui(true)
		
	organize_consumables()

func add_consumable(consumable):
	for i in get_children():
		if i.consumable_stats.name == consumable.name:
			i.consumable_stats.stack_amount += 1
			i.get_node("BaseConsumable").update_stack_ui()
			i.get_node("BaseConsumable").toggle_info_ui(true)
			return
			
	var new_instance = load(consumable.consumable_scene_path).instantiate()
	new_instance.consumable_stats = consumable
	add_child(new_instance)
	new_instance.get_node("BaseConsumable").toggle_info_ui(true)
	organize_consumables()

func remove_consumable(consumable, amount = 1):
	for i in get_children():
		if i.consumable_stats.name == consumable.name:
			i.consumable_stats.stack_amount -= amount
			if i.consumable_stats.stack_amount <= 0:
				remove_child(i)
				i.queue_free()
				organize_consumables()
				return
			i.get_node("BaseConsumable").update_stack_ui()
			i.get_node("BaseConsumable").toggle_info_ui(true)
			organize_consumables()
			return
			
	

func organize_consumables():
	var counter = 0
	var x_offset = 0
	var y_offset = -5
	
	for i in get_children():
		if counter >= 4: 
			x_offset = -32
			y_offset = 0
			counter = 0
		i.position = Vector2(x_offset + CONSUMABLE_X_POSITION, y_offset + CONSUMABLE_Y_POSITION)
		y_offset += 45
		counter += 1

func get_consumable_array():
	var consumable_array = []
	for i in get_children():
		consumable_array.push_back(i.consumable_stats)
	
	return consumable_array
