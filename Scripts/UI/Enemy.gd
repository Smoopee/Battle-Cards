extends Node2D

var trogg = preload("res://Scenes/Enemies/trogg.tscn")
var pirate = preload("res://Scenes/Enemies/pirate.tscn")
var frooty = preload("res://Scenes/Enemies/frooty.tscn")
@onready var card_slots = $"../Enemy_Cards"

func _ready():
	var enemy = frooty.instantiate()
	add_child(enemy)
	display_cards(enemy.enemy_deck)

func display_cards(deck):
	var counter = 0
	for i in deck:
		var temp = card_slots.get_child(counter)
		temp.get_node("CardSlotImage").texture = load(i.card_art_path)
		temp.get_node("Area2D/CollisionShape2D").disabled = true
		counter += 1

