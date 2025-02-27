extends Node2D

@onready var card_manager = $CardManager

var deck = []

func _ready():
	var enemy = Global.current_enemy

func _on_button_button_down():
	for i in card_manager.card_slot_reference:
		deck.push_back(i.path)
	
	Global.player_deck = deck
	
	
	get_tree().change_scene_to_file(("res://Scenes/Battle/battle_sim.tscn"))

