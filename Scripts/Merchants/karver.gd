extends Node2D

var inventory = []
var inventory_selection = []

var merchant_scene_path = "res://Scenes/Merchants/karver.tscn"
var merchant_type = "Runes"

var rune_db_reference

func _ready():
	rune_db_reference = preload("res://Resources/Runes/rune_db.gd")

func get_inventory():
	inventory = []
	inventory_selection = []
	get_inventory_selection()
	create_inventory()
	
func get_inventory_selection():
	for i in rune_db_reference.RUNES:
		var temp = load(rune_db_reference.RUNES[i])
		inventory_selection.push_back(temp)

func create_inventory():
	for i in range(0, 4):
		var selection = random_item_selection().duplicate()
		inventory.push_front(selection)

func random_item_selection():
	var rng = RandomNumberGenerator.new()
	
	var item_selection_index = rng.randi_range(0, inventory_selection.size()-1)
	return inventory_selection[item_selection_index]
