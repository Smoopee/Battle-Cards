extends Node2D

@export var merchant_stats_resource: Merchant_Resource


var inventory = []
var double_up = preload("res://Resources/Cards/double_up.tres")
var strengthen = preload("res://Resources/Cards/strengthen.tres")

var merchant_stats: Merchant_Resource = null
var merchant_scene_path = "res://Scenes/Merchants/buff.tscn"

func _ready():
	set_stats(merchant_stats_resource)

func set_stats(stats = Merchant_Resource) -> void:
	merchant_stats = stats

func get_inventory():
	for i in range(0,2):
		inventory.push_front(double_up)
	
	for i in range(0,2):
		inventory.push_front(strengthen)
		
	return inventory
