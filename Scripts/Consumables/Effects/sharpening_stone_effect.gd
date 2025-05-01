extends Node2D


func effect(card):
	#if Global.current_scene != "battle_sim" : return false
	if card.card_stats.in_enemy_deck == true: return false
	
	card.add_modifier(load("res://Scenes/Modifiers/sharpening_stone_modifier.tscn").instantiate())
	
	return true
