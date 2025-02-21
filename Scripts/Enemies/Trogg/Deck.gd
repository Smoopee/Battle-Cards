extends Node2D

var enemy_deck = []

var rock = preload("res://Resources/Cards/rock.tres")

func _ready():
	for i in range(0, 10):
		enemy_deck.push_back(rock)
	

func build_deck():
	pass
