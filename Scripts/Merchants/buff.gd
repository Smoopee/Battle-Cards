extends Node2D

@export var merchant_stats_resource: Merchant_Resource


var inventory = []
var inventory_selection = []

var merchant_stats: Merchant_Resource = null
var merchant_scene_path = "res://Scenes/Merchants/buff.tscn"

var card_db_reference

func _ready():
	set_stats(merchant_stats_resource)
	card_db_reference = preload("res://Resources/Cards/card_db.gd")


func get_inventory():
	get_inventory_selection()
	create_inventory()

func set_stats(stats = Merchant_Resource) -> void:
	merchant_stats = stats

func get_inventory_selection():
	for i in card_db_reference.CARDS:
		var temp = load(card_db_reference.CARDS[i])
		for j in temp.card_pool:
			if j == "Buff":
				inventory_selection.push_back(temp)

func create_inventory():
	for i in range(0, 4):
		var selection = random_item_selection().duplicate()
		inventory.push_front(selection)
	
	item_upgrade_function()
	for i in inventory:
		print(i.upgrade_level)
	
func random_item_selection():
	var rng = RandomNumberGenerator.new()
	
	var item_selection_index = rng.randi_range(0, inventory_selection.size()-1)
	return inventory_selection[item_selection_index]
	

func item_upgrade_function():
	var rng = RandomNumberGenerator.new()
	
	for i in inventory:
		var upgrade_calc = rng.randi_range(0, 99)
		print("Yoafs")
		print(upgrade_calc)
		if upgrade_calc >= 96: i.upgrade_level = 4
		elif upgrade_calc >= 69: i.upgrade_level = 3
		elif upgrade_calc >= 49: i.upgrade_level = 2
		elif upgrade_calc >= 0: i.upgrade_level = 1
