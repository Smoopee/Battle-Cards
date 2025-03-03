extends Node2D

@export var merchant_stats_resource: Merchant_Resource

var inventory = []
var dagger = preload("res://Resources/Cards/dagger.tres")
var health_potion = preload("res://Resources/Cards/health_potion.tres")

var merchant_stats: Merchant_Resource = null
var merchant_scene_path = "res://Scenes/Merchants/rand_dom.tscn"

func _ready():
	set_stats(merchant_stats_resource)

func set_stats(stats = Merchant_Resource) -> void:
	merchant_stats = stats

func get_inventory():
	for i in range(0,4):
		inventory.push_front(dagger)
	
	for i in range(0,4):
		inventory.push_back(health_potion)
		
	return inventory
