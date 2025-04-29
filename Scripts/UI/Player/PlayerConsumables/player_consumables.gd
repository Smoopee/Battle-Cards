extends Node2D

const CONSUMABLE_X_POSITION = -100
const CONSUMABLE_Y_POSITION = -60
const CONSUMABLE_Y_HORIZONTAL_POSITION = 950

var consumable_orientation = true


func _ready():
	set_consumables()

func set_consumables():
	var player_consumables = Global.player_consumables

	for i in player_consumables:
		var new_instance = load(i.consumable_scene_path).instantiate()
		new_instance.consumable_stats = i
		new_instance.update_stack_ui()
		new_instance.toggle_info_ui(true)
		add_child(new_instance)
	
	organize_consumables()

func add_consumable(consumable):
	for i in get_children():
		if i.consumable_stats.consumable_name == consumable.consumable_name:
			i.consumable_stats.stack_amount += 1
			i.update_stack_ui()
			i.toggle_info_ui(true)
			return
			
	var new_instance = load(consumable.consumable_scene_path).instantiate()
	new_instance.consumable_stats = consumable
	add_child(new_instance)
	organize_consumables()

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
	
	consumable_orientation = true

func _on_consumables_child_order_changed():
	if get_node_or_null("Consumables") == null: return
	if consumable_orientation == true: organize_consumables()
	else: organize_consumables_horiziontal()

func organize_consumables_horiziontal():
	var counter = 0
	for i in get_children():
		i.global_position = Vector2(calculate_consumable_horizontal_position(counter), CONSUMABLE_Y_HORIZONTAL_POSITION)
		counter += 1
	consumable_orientation = false

func calculate_consumable_horizontal_position(index):
	var center_screen_x = get_viewport().size.x / 2
	var total_width = (get_children().size() - 1) * 35
	var x_offset = center_screen_x + index * 35 - total_width / 2
	return x_offset

func get_consumable_array():
	var consumable_array = []
	for i in get_children():
		consumable_array.push_back(i.consumable_stats)
	
	return consumable_array
