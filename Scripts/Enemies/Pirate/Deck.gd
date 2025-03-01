extends Node2D

var enemy_deck = []

var dagger = preload("res://Resources/Cards/dagger.tres")

func _ready():
	var temp = load(dagger.card_scene_path).instantiate()
	temp.set_stats()
	temp.upgrade_card(2)
	for i in range(0, 10):
		enemy_deck.push_back(dagger)
	temp.upgrade_card(1)

