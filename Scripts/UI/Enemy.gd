extends Node2D

@onready var card_slots = $"../Enemy_Cards"

func _ready():
	var enemy = load(Global.current_enemy).instantiate()
	add_child(enemy)
	display_cards(enemy.enemy_deck)

func display_cards(deck):
	var counter = 0
	for i in deck:
		var temp = card_slots.get_child(counter)
		temp.get_node("CardSlotImage").texture = load(i.card_art_path)
		temp.get_node("Area2D/CollisionShape2D").disabled = true
		counter += 1

