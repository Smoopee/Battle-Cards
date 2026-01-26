extends Node2D

const SKILL_WIDTH = 160
const INVENTORY_Y_POSITION = 376

var inventory_db = []
var inventory = []
var center_screen_x
var animation_canel = true

func _ready():
	center_screen_x = get_viewport().size.x / 2

func create_merchant_inventory():
	fetch_merchant_inventory()
	skill_upgrade_function()
	
	for i in range(inventory_db.size()):
		var skill_scene = load(inventory_db[i].skill_scene_path).instantiate()
		skill_scene.skill_stats = inventory_db[i]
		add_child(skill_scene)
		add_skill_to_inventory(skill_scene)
		skill_scene.upgrade_skill(skill_scene.skill_stats.upgrade_level)
	
	var skill_position = 0
	for i in inventory:
		i.get_node("BaseSkill").get_node("Area2D").collision_mask = 512
		i.get_node("BaseSkill").get_node("Area2D").collision_layer = 512
		i.get_node("BaseSkill").toggle_shop_ui(true)
		i.get_node("BaseSkill").skill_shop_ui()
		i.skill_stats.inventory_position = skill_position
		i.skill_stats.owner = get_tree().get_first_node_in_group("merchant")
		skill_position += 1

func fetch_merchant_inventory():
	var merchant_reference = get_tree().get_first_node_in_group("merchant").get_child(0)
	merchant_reference.get_inventory()
	inventory_db = merchant_reference.inventory

func skill_upgrade_function():
	var rng = RandomNumberGenerator.new()
	
	for i in inventory_db:
		var upgrade_calc = rng.randi_range(0, 99)
		if upgrade_calc >= 96: i.upgrade_level = 4
		elif upgrade_calc >= 69: i.upgrade_level = 3
		elif upgrade_calc >= 49: i.upgrade_level = 2
		elif upgrade_calc >= 0: i.upgrade_level = 1
	
	player_skill_upgrade_match()
	
func player_skill_upgrade_match():
	var player_skills = []
	for j in Global.player_skills:
		player_skills.push_back(j.name)
		
	for i in inventory_db:
		if player_skills.find(i.name) > -1:
			i.upgrade_level = Global.player_skills[player_skills.find(i.name)].upgrade_level

func add_skill_to_inventory(skill):
	if skill not in inventory:
		inventory.push_back(skill)
		update_inventory_positions()
	else:
		animate_skill_to_position(skill, skill.skill_stats.screen_position)

func update_inventory_positions():
	for i in range(inventory.size()):
		var new_position = Vector2(calculate_skill_position(i), INVENTORY_Y_POSITION)
		var skill = inventory[i]
		skill.skill_stats.screen_position = new_position
		skill.position = new_position
 
func calculate_skill_position(index):
	var more_space = 0
	if inventory.size() > 6:
		more_space = 30
	if inventory.size() > 12:
		more_space = 50
	var total_width = (inventory.size() - 1) * (SKILL_WIDTH - more_space)
	var x_offset = center_screen_x + (index * (SKILL_WIDTH - more_space)) - (total_width / 2)
	return x_offset

func remove_skill_from_inventory(skill):
	if skill in inventory:
		inventory.erase(skill)
		update_inventory_positions()

func animate_skill_to_position(skill, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(skill, "position", new_position, 0.1)
