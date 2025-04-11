extends Node2D

const CONSUMABLE_WIDTH = 160
const INVENTORY_Y_POSITION = 376

var inventory = []
var inventory_selection = []
var selected_inventory = []

var consumable_db_reference
var center_screen_x


func setup(tag):
	consumable_db_reference = preload("res://Resources/Consumables/consumable_db.gd")
	center_screen_x = get_viewport().size.x / 2
	get_inventory(tag)
	get_tree().get_first_node_in_group("card selector").visible = false
	get_tree().get_first_node_in_group("player inventory").get_node("SellZone").visible = false

func get_inventory(tag):
	get_inventory_selection(tag)
	create_inventory()
	create_consumable_selection()

func get_inventory_selection(tag):
	for i in consumable_db_reference.CONSUMABLES:
		var temp = load(consumable_db_reference.CONSUMABLES[i])
		for j in temp.tags:
			if j == tag:
				inventory_selection.push_back(temp)

func create_inventory():
	for i in range(0, 4):
		var selection = random_item_selection().duplicate()
		inventory.push_front(selection)
	
	
func random_item_selection():
	var rng = RandomNumberGenerator.new()
	
	var item_selection_index = rng.randi_range(0, inventory_selection.size()-1)
	return inventory_selection[item_selection_index]
	


#DISPLAY CONSUMABLES ===============================================================================
func create_consumable_selection():

	for i in range(inventory.size()):
		var consumable_scene = load(inventory[i].consumable_scene_path).instantiate()
		consumable_scene.consumable_stats = inventory[i]
		get_tree().get_first_node_in_group("organizer").add_child(consumable_scene)
		add_consumable_to_hand(consumable_scene)

	
	var consumable_position = 0
	for i in selected_inventory:
		i.get_node("Area2D").collision_mask =  8192
		i.get_node("Area2D").collision_layer = 8192
		i.consumable_stats.buy_price *= 2
		i.toggle_shop_ui(true)
		i.consumable_shop_ui()
		i.get_node("ConsumableImage").scale = Vector2(2, 2)
		i.get_node("Area2D").scale = Vector2(2,2)
		i.consumable_stats.inventory_position = consumable_position
		i.consumable_stats.consumable_owner = false
		consumable_position += 1

func add_consumable_to_hand(consumable):
	if consumable not in selected_inventory:
		selected_inventory.push_back(consumable)
		update_hand_positions()
	else:
		animate_consumable_to_position(consumable, consumable.consumable_stats.screen_position)

func update_hand_positions():
	for i in range(selected_inventory.size()):
		var new_position = Vector2(calculate_consumable_position(i), INVENTORY_Y_POSITION)
		var consumable = selected_inventory[i]
		consumable.consumable_stats.screen_position = new_position
		consumable.position = new_position
 
func calculate_consumable_position(index):
	var more_space = 0
	if selected_inventory.size() > 6:
		more_space = 30
	if selected_inventory.size() > 12:
		more_space = 50
	var total_width = (selected_inventory.size() - 1) * (CONSUMABLE_WIDTH - more_space)
	var x_offset = center_screen_x + (index * (CONSUMABLE_WIDTH - more_space)) - (total_width / 2)
	return x_offset

func remove_consumable_from_inventory(consumable):
	if consumable in selected_inventory:
		selected_inventory.erase(consumable)
		update_hand_positions()

func animate_consumable_to_position(consumable, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(consumable, "position", new_position, 0.1)
