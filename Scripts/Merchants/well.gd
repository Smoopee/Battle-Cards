extends Node2D

var inventory = []
var bleed_enchant_card = preload("res://Resources/Cards/CardEnchants/bleed_enchant_card.tres")

var merchant_scene_path = "res://Scenes/Merchants/well.tscn"

var card_db_reference

func _ready():
	card_db_reference = preload("res://Resources/Cards/card_db.gd")
	
func get_inventory():
	inventory = []
	for i in range(0,5):
		inventory.push_front(bleed_enchant_card)
		
	return inventory
