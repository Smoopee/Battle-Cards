extends Node2D

var enemy_deck = []

var rock = preload("res://Resources/Cards/rock.tres")
var health_potion = preload("res://Resources/Cards/health_potion.tres")

func _ready():
	for i in range(0, 5):
		enemy_deck.push_back(rock)
	
	for i in range(5, 10):
		enemy_deck.push_back(health_potion)
