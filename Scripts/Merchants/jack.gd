extends Node2D


var inventory = []
var inventory_selection = []

var merchant_scene_path = "res://Scenes/Merchants/jack.tscn"
var merchant_type = "Skill"

var skill_db_reference

func _ready():
	skill_db_reference = preload("res://Resources/Skills/skill_db.gd")


func get_inventory():
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

func random_item_selection():
	var rng = RandomNumberGenerator.new()
	
	var item_selection_index = rng.randi_range(0, inventory_selection.size()-1)
	return inventory_selection[item_selection_index]
