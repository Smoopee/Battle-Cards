extends Node2D

class_name Merchant

var inventory = []
var inventory_selection = []
var merchant_stats: Merchant_Resource = null
var db_reference


var merchant_variables : Node2D
var merchant_image : Sprite2D
var border_image : Sprite2D


func _ready():
	set_node_names()
	get_db_reference()
	add_to_group("merchant")

func set_node_names():
	merchant_variables = get_node('%MerchantVariables')
	merchant_image = get_node('%MerchantImage')
	border_image = get_node('%BorderImage')
	
	merchant_image.texture = load(merchant_stats.merchant_art_path)
	border_image.texture = load(merchant_stats.merchant_border_path)

func get_db_reference():
	match merchant_stats.merchant_type:
		"Card":
			db_reference = preload("res://Resources/Cards/card_db.gd")
		"Rune":
			db_reference = preload("res://Resources/Runes/rune_db.gd")
		"Skill":
			db_reference = preload("res://Resources/Skills/skill_db.gd")
		"Consumable":
			db_reference = preload("res://Resources/Consumables/consumable_db.gd")
		"Enchantment":
			db_reference = preload("res://Resources/Enchantments/enchantment_db.gd")

func get_inventory():
	inventory = []
	inventory_selection = []
	get_inventory_selection()
	create_inventory()
	
	
	if merchant_stats.merchant_type == "Skill" or merchant_stats.merchant_type == "Card":
		item_upgrade_function()
	
	
func get_inventory_selection():
	if merchant_stats.selection_tags == []:
		for i in db_reference.ITEMS:
			var temp = load(db_reference.ITEMS[i])
			inventory_selection.push_back(temp)
	
	else:
		for i in merchant_stats.selection_tags:
			for j in db_reference.ITEMS:
				var temp = load(db_reference.ITEMS[j])
				if temp.tags.find(i) > -1 : 
					inventory_selection.push_back(temp)

	
func create_inventory():
	for i in range(0, merchant_stats.stock_quantity):
		var selection = random_item_selection().duplicate()
		inventory.push_front(selection)

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
