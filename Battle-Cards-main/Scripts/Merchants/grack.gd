extends Node2D


var inventory = []
var rock = preload("res://Resources/Cards/rock.tres")

var merchant_scene_path = "res://Scenes/Merchants/grack.tscn"
var merchant_type = "Card"

var card_db_reference

func _ready():
	card_db_reference = preload("res://Resources/Cards/card_db.gd")

func get_inventory():
	rock.upgrade_level = 1

	inventory = []
	for i in range(0,5):
		inventory.push_front(rock)
		
	return inventory
