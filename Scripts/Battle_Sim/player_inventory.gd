extends Node2D


var inventory_db = []
var inventory = []

func initial_build_inventory():
	inventory = []
	inventory_db = Global.player_inventory

	var counter = 0
	
	var card_position = 0
	for i in range(inventory_db.size()):
		if inventory_db[i] == null:
			inventory.push_back(null)
		else:
			var new_card = load(inventory_db[i].card_scene_path).instantiate()
			inventory.push_back(new_card)
			new_card.card_stats = inventory_db[i]
			add_child(new_card)
			new_card.upgrade_card(new_card.card_stats.upgrade_level)
			new_card.item_enchant(new_card.card_stats.item_enchant)
			new_card.card_stats.owner = get_tree().get_first_node_in_group("character")
			new_card.card_stats.target = get_tree().get_first_node_in_group("enemy")
			new_card.card_stats.is_players = true
			new_card.card_stats.inventory_position = counter
			new_card.update_card_ui()
		counter += 1

	return inventory

func build_inventory():
	var counter = 0
	inventory = []
	var card_position = 0
	for i in $"../NextTurn/DeckBuilder/CardManager".inventory_card_slot_reference:
		inventory.push_back(i)
		#i.card_stats.inventory_position = counter
		#counter += 1
		if i != null: i.reparent(self)

	return inventory

func clear_cards():
	for i in get_children():
		if i.is_in_group("card"):
			i.queue_free()
