extends Node2D

var enemy_deck = []

var dagger = preload("res://Resources/Cards/dagger.tres")

func _ready():
	var item1 = dagger.duplicate()
	var item2 = dagger.duplicate()
	var item3 = dagger.duplicate()
	var item4 = dagger.duplicate()
	var item5 = dagger.duplicate()
	var item6 = dagger.duplicate()
	var item7 = dagger.duplicate()
	var item8 = dagger.duplicate()
	var item9 = dagger.duplicate()
	var item10 = dagger.duplicate()
	
	item1.upgrade_level = 2
	item2.upgrade_level = 3
	item3.upgrade_level = 2


	var deck = [item1, item2, item3, item4, item5, item6, item7, item8, item9, item10]
	
	enemy_deck = deck


