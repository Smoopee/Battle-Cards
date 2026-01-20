extends Node2D

var player_skill = true

func effect():
	if player_skill:
		for i in get_parent().get_parent().player_deck_list:
			if i.get_child(Global.card_node_reference).is_in_group("weapon"):
				print("Honed Edge Activated")
				i.card_resource.dmg += 5
				break
	else:
		for i in get_parent().get_parent().enemy_deck_list:
				if i.get_child(Global.card_node_reference).is_in_group("weapon"):
					print("Enemy Honed Edge Activated")
					i.card_resource.dmg += 5
					break
