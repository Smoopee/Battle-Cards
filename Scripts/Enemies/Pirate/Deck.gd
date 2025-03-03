extends Node2D

var enemy_deck = []

var dagger = preload("res://Resources/Cards/dagger.tres")

func _ready():
	var temp = load("res://Scenes/Cards/dagger.tscn").instantiate()
	var dagger1 = dagger.duplicate()
	var dagger2 = dagger.duplicate()
	var dagger3 = dagger.duplicate()
	var dagger4 = dagger.duplicate()
	var dagger5 = dagger.duplicate()
	var dagger6 = dagger.duplicate()
	var dagger7 = dagger.duplicate()
	var dagger8 = dagger.duplicate()
	var dagger9 = dagger.duplicate()
	var dagger10 = dagger.duplicate()
	
	dagger1.upgrade_level = 2
	dagger2.upgrade_level = 3
	dagger3.upgrade_level = 2


	var deck = [dagger1, dagger2, dagger3, dagger4, dagger5, dagger6, dagger7, dagger8, dagger9, dagger10]
	
	enemy_deck = deck


