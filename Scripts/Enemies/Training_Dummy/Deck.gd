extends Node2D

var enemy_deck = []

var jab = preload("res://Resources/Cards/jab.tres")


func _ready():
	var item1 = jab.duplicate()
	var item2 = jab.duplicate()
	var item3 = jab.duplicate()
	var item4 = jab.duplicate()
	var item5 = jab.duplicate()
	var item6 = jab.duplicate()
	var item7 = jab.duplicate()
	var item8 = jab.duplicate()
	var item9 = jab.duplicate()
	var item10 = jab.duplicate()

	
	var deck = [item1, item2, item3, item4, item5, item6, item7, item8, item9, item10]
	
	enemy_deck = deck

