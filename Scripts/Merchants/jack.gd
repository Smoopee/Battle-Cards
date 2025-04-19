extends Node2D


var inventory = []
var inventory_selection = []

var merchant_scene_path = "res://Scenes/Merchants/jack.tscn"
var merchant_type = "Skill"

var skill_db_reference

func _ready():
	skill_db_reference = preload("res://Resources/Skills/skill_db.gd")

func get_inventory():
	inventory = []
	inventory_selection = []
	get_inventory_selection()
	create_inventory()
	
func get_inventory_selection():
	for i in skill_db_reference.SKILLS:
		var temp = load(skill_db_reference.SKILLS[i])
		inventory_selection.push_back(temp)

func create_inventory():
	for i in range(0, 4):
		var selection = random_item_selection().duplicate()
		inventory.push_front(selection)
		
	skill_upgrade_function()

func random_item_selection():
	var rng = RandomNumberGenerator.new()
	
	var item_selection_index = rng.randi_range(0, inventory_selection.size()-1)
	return inventory_selection[item_selection_index]

func skill_upgrade_function():
	var rng = RandomNumberGenerator.new()
	
	for i in inventory:
		var upgrade_calc = rng.randi_range(0, 99)
		if upgrade_calc >= 96: i.upgrade_level = 4
		elif upgrade_calc >= 69: i.upgrade_level = 3
		elif upgrade_calc >= 49: i.upgrade_level = 2
		elif upgrade_calc >= 0: i.upgrade_level = 1
