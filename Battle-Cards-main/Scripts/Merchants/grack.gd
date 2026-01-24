extends Node2D

@onready var stats = merchant_stats
@onready var merchant = $BaseMerchant

var merchant_stats: Merchant_Resource = null

var inventory = []
var rock = preload("res://Resources/Cards/rock.tres")

var merchant_scene_path = "res://Scenes/Merchants/grack.tscn"
var merchant_type = "Card"

var card_db_reference


func _ready():
	tooltip_merchant()
	card_db_reference = preload("res://Resources/Cards/card_db.gd")

func get_inventory():
	rock.upgrade_level = 1

	inventory = []
	for i in range(0,5):
		inventory.push_front(rock)
		
	return inventory

func tooltip_merchant():
	merchant.update_tooltip(str(merchant_stats.merchant_name), 
	"Flavor Text", 
	"Likes to smash", 
	"")
