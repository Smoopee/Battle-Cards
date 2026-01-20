extends Node2D

const SKILL_WIDTH = 250
const HAND_Y_POSITION = 376

var inventory = []
var inventory_selection = []
var selected_inventory = []

var skill_db_reference
var center_screen_x


func setup():
	skill_db_reference = preload("res://Resources/Skills/skill_db.gd")
	center_screen_x = get_viewport().size.x / 2
	get_inventory()
	get_tree().get_first_node_in_group("card selector").visible = false
	get_tree().get_first_node_in_group("player cards").get_node("SellZone").visible = false


func get_inventory():
	get_inventory_selection()
	create_inventory()
	create_skill_selection()

func get_inventory_selection():
	for i in skill_db_reference.ITEMS:
		var temp = load(skill_db_reference.ITEMS[i])
		for j in temp.tags:
			if j == "Berserker":
				inventory_selection.push_back(temp)

func create_inventory():
	for i in range(0, 4):
		var selection = random_item_selection().duplicate()
		inventory.push_front(selection)
	
	item_upgrade_function()
	
func random_item_selection():
	var rng = RandomNumberGenerator.new()
	
	var item_selection_index = rng.randi_range(0, inventory_selection.size()-1)
	return inventory_selection[item_selection_index]
	

func item_upgrade_function():
	var rng = RandomNumberGenerator.new()
	
	for i in inventory:
		var upgrade_calc = rng.randi_range(0, 99)
		if upgrade_calc >= 96: i.upgrade_level = 4
		elif upgrade_calc >= 69: i.upgrade_level = 3
		elif upgrade_calc >= 49: i.upgrade_level = 2
		elif upgrade_calc >= 0: i.upgrade_level = 1


#Display Skills ====================================================================================
func create_skill_selection():

	for i in range(inventory.size()):
		var skill_scene = load(inventory[i].skill_scene_path).instantiate()
		skill_scene.skill_stats = inventory[i]
		add_child(skill_scene)
		add_skill_to_hand(skill_scene)
		skill_scene.upgrade_skill(skill_scene.skill_stats.upgrade_level)
	
	var skill_position = 0
	for i in selected_inventory:
		i.get_node("Area2D").collision_mask = 512
		i.get_node("Area2D").collision_layer = 512
		i.skill_stats.buy_price *= 2
		i.toggle_shop_ui(true)
		i.skill_shop_ui()
		i.skill_stats.inventory_position = skill_position
		i.skill_stats.owner = false
		skill_position += 1

func add_skill_to_hand(skill):
	if skill not in selected_inventory:
		selected_inventory.push_back(skill)
		update_hand_positions()
	else:
		animate_skill_to_position(skill, skill.skill_stats.screen_position)

func update_hand_positions():
	for i in range(selected_inventory.size()):
		var new_position = Vector2(calculate_skill_position(i), HAND_Y_POSITION)
		var skill = selected_inventory[i]
		skill.skill_stats.screen_position = new_position
		skill.position = new_position
 
func calculate_skill_position(index):
	var more_space = 0
	if selected_inventory.size() > 6:
		more_space = 30
	if selected_inventory.size() > 12:
		more_space = 50
	var total_width = (selected_inventory.size() - 1) * (SKILL_WIDTH - more_space)
	var x_offset = center_screen_x + (index * (SKILL_WIDTH - more_space)) - (total_width / 2)
	return x_offset

func remove_skill_from_inventory(skill):
	if skill in selected_inventory:
		selected_inventory.erase(skill)
		update_hand_positions()

func animate_skill_to_position(skill, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(skill, "position", new_position, 0.1)
