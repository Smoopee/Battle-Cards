extends Node2D

var player_skill = true


func effect():
	if player_skill:
		for i in get_parent().get_parent().player_deck_list:
			if i.is_in_group("weapon"):
				i.card_stats.dmg += 5
				break
	else:
		print("Honed Edge Activated")
		for i in get_parent().get_parent().enemy_deck_list:
				if i.is_in_group("weapon"):
					i.card_stats.dmg += 5
					break
