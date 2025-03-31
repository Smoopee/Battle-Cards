extends Node2D

const CONSUMABLE_WIDTH = 160
const INVENTORY_Y_POSITION = 376

var inventory_db = []
var inventory = []
var center_screen_x
var animation_canel = true

func _ready():
	center_screen_x = get_viewport().size.x / 2

func create_merchant_inventory():
	fetch_merchant_inventory()
	
	for i in range(inventory_db.size()):
		var consumable_scene = load(inventory_db[i].consumable_scene_path).instantiate()
		consumable_scene.consumable_stats = inventory_db[i]
		add_child(consumable_scene)
		add_consumable_to_inventory(consumable_scene)
	
	var consumable_position = 0
	for i in inventory:
		i.get_node("Area2D").collision_mask = 8192
		i.get_node("Area2D").collision_layer = 8192
	
		i.toggle_shop_ui(true)
		i.consumable_shop_ui()
		i.consumable_stats.inventory_position = consumable_position
		i.consumable_stats.consumable_owner = get_tree().get_first_node_in_group("merchant")
		i.get_node("ConsumableImage").scale = Vector2(2, 2)
		i.get_node("Area2D").scale = Vector2(2,2)
		consumable_position += 1

func fetch_merchant_inventory():
	$"../Merchant".get_child(0).get_inventory()
	inventory_db = $"../Merchant".get_child(0).inventory

func add_consumable_to_inventory(consumable):
	if consumable not in inventory:
		inventory.push_back(consumable)
		update_inventory_positions()
	else:
		animate_consumable_to_position(consumable, consumable.consumable_stats.screen_position)

func update_inventory_positions():
	for i in range(inventory.size()):
		var new_position = Vector2(calculate_consumable_position(i), INVENTORY_Y_POSITION)
		var consumable = inventory[i]
		consumable.consumable_stats.screen_position = new_position
		consumable.position = new_position
 
func calculate_consumable_position(index):
	var more_space = 0
	if inventory.size() > 6:
		more_space = 30
	if inventory.size() > 12:
		more_space = 50
	var total_width = (inventory.size() - 1) * (CONSUMABLE_WIDTH - more_space)
	var x_offset = center_screen_x + (index * (CONSUMABLE_WIDTH - more_space)) - (total_width / 2)
	return x_offset

func remove_consumable_from_inventory(consumable):
	if consumable in inventory:
		inventory.erase(consumable)
		update_inventory_positions()

func animate_consumable_to_position(consumable, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(consumable, "position", new_position, 0.1)
