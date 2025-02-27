extends Node2D

@export var merchant_stats_resource: Merchant_Resource

var inventory = []
var rock = preload("res://Resources/Cards/rock.tres")

var merchant_stats: Merchant_Resource = null
var merchant_scene_path = "res://Scenes/Merchants/grack.tscn"

func _ready():
	set_stats(merchant_stats_resource)

func set_stats(stats = Merchant_Resource) -> void:
	merchant_stats = stats

func get_inventory():
	for i in range(0,10):
		inventory.push_front(rock)
		
	return inventory
