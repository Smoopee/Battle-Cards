extends Node2D

var enemy_deck = []

var rock = preload("res://Resources/Cards/rock.tres")
var health_potion = preload("res://Resources/Cards/health_potion.tres")

func _ready():
	var item1 = rock.duplicate()
	var item2 = rock.duplicate()
	var item3 = rock.duplicate()
	var item4 = rock.duplicate()
	var item5 = rock.duplicate()
	var item6 = health_potion.duplicate()
	var item7 = health_potion.duplicate()
	var item8 = health_potion.duplicate()
	var item9 = health_potion.duplicate()
	var item10 = health_potion.duplicate()
	
	item3.item_enchant = "Bleed"
	item3.upgrade_level = 2
	item7.upgrade_level = 3
	
	
	var deck = [item1, item2, item3, item4, item5, item6, item7, item8, item9, item10]
	
	enemy_deck = deck
