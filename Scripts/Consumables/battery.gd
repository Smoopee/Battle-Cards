extends Node2D


func activate_consumable():
	var cards = (get_tree().get_nodes_in_group("card"))
	for i in cards:
		if i.card_resource.is_players and i.card_resource.card_type == "Weapon":
			i.card_resource.dmg += 2
			i.update_card_ui()
