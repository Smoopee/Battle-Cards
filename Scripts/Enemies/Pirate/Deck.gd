extends Node2D

var enemy_deck = []

var dagger = preload("res://Resources/Cards/dagger.tres")

func _ready():
	for i in range(0, 10):
		enemy_deck.push_back(dagger)

