extends Node2D

var inventory = []
var rock = preload("res://Resources/Cards/rock.tres")

func _ready():
	pass

func get_inventory():
	for i in range(0,10):
		inventory.push_front(rock)
		
	return inventory
