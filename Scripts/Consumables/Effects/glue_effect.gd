extends Node2D


func effect(card):
	#if Global.current_scene != "battle_sim" or "deck_builder": return false
	if card.card_stats.in_enemy_deck != true: return false
	
	
	card.card_stats.on_cd = true
	card.add_modifier(load("res://Scenes/Modifiers/glue_modifier.tscn").instantiate())
	
	return true
