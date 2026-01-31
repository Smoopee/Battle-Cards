extends Node2D

const GADGET_WIDTH = 160
const INVENTORY_Y_POSITION = 376

var inventory_db = []
var inventory = []
var center_screen_x
var animation_canel = true

func _ready():
	center_screen_x = get_viewport().size.x / 2

func create_merchant_inventory():
	fetch_merchant_inventory()
	gadget_upgrade_function()
	
	for i in range(inventory_db.size()):
		var gadget_scene = load(inventory_db[i].gadget_scene_path).instantiate()
		gadget_scene.gadget_stats = inventory_db[i]
		add_child(gadget_scene)
		add_gadget_to_inventory(gadget_scene)
		gadget_scene.upgrade_gadget(gadget_scene.gadget_stats.upgrade_level)
	
	var gadget_position = 0
	for i in inventory:
		i.get_node("BaseGadget").get_node("Area2D").collision_mask = 8388608
		i.get_node("BaseGadget").get_node("Area2D").collision_layer = 8388608
		i.get_node("BaseGadget").toggle_shop_ui(true)
		i.get_node("BaseGadget").gadget_shop_ui()
		i.gadget_stats.inventory_position = gadget_position
		i.gadget_stats.owner = get_tree().get_first_node_in_group("merchant")
		gadget_position += 1

func fetch_merchant_inventory():
	var merchant_reference = get_tree().get_first_node_in_group("merchant").get_child(0)
	merchant_reference.get_inventory()
	inventory_db = merchant_reference.inventory

func gadget_upgrade_function():
	var rng = RandomNumberGenerator.new()
	
	for i in inventory_db:
		var upgrade_calc = rng.randi_range(0, 99)
		if upgrade_calc >= 96: i.upgrade_level = 4
		elif upgrade_calc >= 69: i.upgrade_level = 3
		elif upgrade_calc >= 49: i.upgrade_level = 2
		elif upgrade_calc >= 0: i.upgrade_level = 1
	
	player_gadget_upgrade_match()
	
func player_gadget_upgrade_match():
	var player_gadgets = []
	for j in Global.player_gadgets:
		player_gadgets.push_back(j.name)
		
	for i in inventory_db:
		if player_gadgets.find(i.name) > -1:
			i.upgrade_level = Global.player_gadgets[player_gadgets.find(i.name)].upgrade_level

func add_gadget_to_inventory(gadget):
	if gadget not in inventory:
		inventory.push_back(gadget)
		update_inventory_positions()
	else:
		animate_gadget_to_position(gadget, gadget.gadget_stats.screen_position)

func update_inventory_positions():
	for i in range(inventory.size()):
		var new_position = Vector2(calculate_gadget_position(i), INVENTORY_Y_POSITION)
		var gadget = inventory[i]
		gadget.gadget_stats.screen_position = new_position
		gadget.position = new_position
 
func calculate_gadget_position(index):
	var more_space = 0
	if inventory.size() > 6:
		more_space = 30
	if inventory.size() > 12:
		more_space = 50
	var total_width = (inventory.size() - 1) * (GADGET_WIDTH - more_space)
	var x_offset = center_screen_x + (index * (GADGET_WIDTH - more_space)) - (total_width / 2)
	return x_offset

func remove_gadget_from_inventory(gadget):
	if gadget in inventory:
		inventory.erase(gadget)
		update_inventory_positions()

func animate_gadget_to_position(gadget, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(gadget, "position", new_position, 0.1)
