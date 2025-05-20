extends Node2D

const ENCHANTMENT_WIDTH = 160
const INVENTORY_Y_POSITION = 376

var inventory_db = []
var inventory = []
var center_screen_x


func _ready():
	center_screen_x = get_viewport().size.x / 2

func create_merchant_inventory():
	fetch_merchant_inventory()
	
	for i in range(inventory_db.size()):
		var enchantment_scene = load(inventory_db[i].enchantment_scene_path).instantiate()
		enchantment_scene.enchantment_stats = inventory_db[i]
		add_child(enchantment_scene)
		add_enchantment_to_inventory(enchantment_scene)
	
	var enchantment_position = 0
	for i in inventory:
		i.get_node("BaseEnchantment").get_node("Area2D").collision_mask = 131072
		i.get_node("BaseEnchantment").get_node("Area2D").collision_layer = 131072
	
		i.get_node("BaseEnchantment").toggle_shop_ui(true)
		i.get_node("BaseEnchantment").enchantment_shop_ui()
		i.enchantment_stats.inventory_position = enchantment_position
		i.enchantment_stats.enchantment_owner = get_tree().get_first_node_in_group("merchant")
		enchantment_position += 1

func fetch_merchant_inventory():
	$"../Merchant".get_child(0).get_inventory()
	inventory_db = $"../Merchant".get_child(0).inventory

func add_enchantment_to_inventory(enchantment):
	if enchantment not in inventory:
		inventory.push_back(enchantment)
		update_inventory_positions()
	else:
		animate_enchantment_to_position(enchantment, enchantment.enchantment_stats.screen_position)

func update_inventory_positions():
	for i in range(inventory.size()):
		var new_position = Vector2(calculate_enchantment_position(i), INVENTORY_Y_POSITION)
		var enchantment = inventory[i]
		enchantment.enchantment_stats.screen_position = new_position
		enchantment.position = new_position
 
func calculate_enchantment_position(index):
	var more_space = 0
	if inventory.size() > 6:
		more_space = 30
	if inventory.size() > 12:
		more_space = 50
	var total_width = (inventory.size() - 1) * (ENCHANTMENT_WIDTH - more_space)
	var x_offset = center_screen_x + (index * (ENCHANTMENT_WIDTH - more_space)) - (total_width / 2)
	return x_offset

func remove_enchantment_from_inventory(enchantment):
	if enchantment in inventory:
		inventory.erase(enchantment)
		update_inventory_positions()

func animate_enchantment_to_position(enchantment, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(enchantment, "position", new_position, 0.1)
