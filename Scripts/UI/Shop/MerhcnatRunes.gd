extends Node2D

const RUNE_WIDTH = 160
const INVENTORY_Y_POSITION = 376

var inventory_db = []
var inventory = []
var center_screen_x


func _ready():
	center_screen_x = get_viewport().size.x / 2

func create_merchant_inventory():
	fetch_merchant_inventory()
	
	for i in range(inventory_db.size()):
		var rune_scene = load(inventory_db[i].rune_scene_path).instantiate()
		rune_scene.rune_stats = inventory_db[i]
		add_child(rune_scene)
		add_rune_to_inventory(rune_scene)
	
	var rune_position = 0
	for i in inventory:
		i.get_node("Area2D").collision_mask = 65536 
		i.get_node("Area2D").collision_layer = 65536 
	
		i.toggle_shop_ui(true)
		i.rune_shop_ui()
		i.rune_stats.inventory_position = rune_position
		i.rune_stats.rune_owner = get_tree().get_first_node_in_group("merchant")
		i.get_node("RuneImage").scale = Vector2(2, 2)
		i.get_node("Area2D").scale = Vector2(2,2)
		rune_position += 1

func fetch_merchant_inventory():
	$"../Merchant".get_child(0).get_inventory()
	inventory_db = $"../Merchant".get_child(0).inventory

func add_rune_to_inventory(rune):
	if rune not in inventory:
		inventory.push_back(rune)
		update_inventory_positions()
	else:
		animate_rune_to_position(rune, rune.rune_stats.screen_position)

func update_inventory_positions():
	for i in range(inventory.size()):
		var new_position = Vector2(calculate_rune_position(i), INVENTORY_Y_POSITION)
		var rune = inventory[i]
		rune.rune_stats.screen_position = new_position
		rune.position = new_position
 
func calculate_rune_position(index):
	var more_space = 0
	if inventory.size() > 6:
		more_space = 30
	if inventory.size() > 12:
		more_space = 50
	var total_width = (inventory.size() - 1) * (RUNE_WIDTH - more_space)
	var x_offset = center_screen_x + (index * (RUNE_WIDTH - more_space)) - (total_width / 2)
	return x_offset

func remove_rune_from_inventory(rune):
	if rune in inventory:
		inventory.erase(rune)
		update_inventory_positions()

func animate_rune_to_position(rune, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(rune, "position", new_position, 0.1)
