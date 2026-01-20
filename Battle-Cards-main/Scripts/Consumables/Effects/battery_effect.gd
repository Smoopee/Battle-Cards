extends Node2D


func effect(card):
	print("In battery consumable")
	if Global.current_scene != "battle_sim": return false
	if card.card_stats.cd_remaining <= 0: return false
	card.change_cd_remaining(-2)
	return true
