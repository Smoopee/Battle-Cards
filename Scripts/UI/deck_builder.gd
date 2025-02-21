extends Node2D


@onready var card_manager = $CardManager

var deck = []

func _ready():
	pass

func _on_button_button_down():
	for i in card_manager.card_slot_reference:
		deck.push_back(i.path)
	
	Global.player_deck = deck
	Global.current_enemy = $Enemy.get_child(0).enemy_scene_path
	
	print(deck)
	
	get_tree().change_scene_to_file(("res://Scenes/battle_sim.tscn"))

