extends Node2D


func activate_consumable():
	var cards = (get_tree().get_nodes_in_group("card"))
	for i in cards:
		if i.card_stats.is_players and i.is_in_group("weapon"):
			i.card_stats.dmg += 2
			i.update_card_ui()
