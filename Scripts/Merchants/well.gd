extends Node2D

@export var merchant_stats_resource: Merchant_Resource

var inventory = []
var bleed_enchant_card = preload("res://Resources/Cards/CardEnchants/bleed_enchant_card.tres")

var merchant_stats: Merchant_Resource = null
var merchant_scene_path = "res://Scenes/Merchants/well.tscn"

func _ready():
	set_stats(merchant_stats_resource)

func set_stats(stats = Merchant_Resource) -> void:
	merchant_stats = stats

func get_inventory():
	inventory = []
	for i in range(0,5):
		inventory.push_front(bleed_enchant_card)
		
	return inventory
