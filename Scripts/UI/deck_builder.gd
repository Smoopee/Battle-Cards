extends Node2D

@onready var card_manager = $CardManager

var deck = []

func _ready():
	var enemy = Global.current_enemy

func _on_button_button_down():
	var blank = load("res://Resources/Cards/blank.tres")
	
	for i in card_manager.card_slot_reference:
		if i != null:
			deck.push_back(i.card_resource)
		else:
			deck.push_back(blank)
	
	while deck.size() < 10:
		deck.push_back(blank)
		
	Global.player_deck = deck


	get_tree().change_scene_to_file(("res://Scenes/Battle/battle_sim.tscn"))

