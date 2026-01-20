extends Node2D

@onready var parent = $".."

func effect(card):
	#if Global.current_scene != "battle_sim" : return false
	if card.card_stats.in_enemy_deck == true: return false
	
	card.get_node("BaseCard").add_modifier(load("res://Scenes/Modifiers/sharpening_stone_modifier.tscn").instantiate())
	
	return true

func tooltip_effect():
	var stats = parent.consumable_stats
	parent.update_tooltip(str(stats.name), 
	"Effect", 
	"Increase Atk by " + str(stats.effect1), 
	"Effect:")
