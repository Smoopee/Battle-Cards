extends Node2D


func next_turn():
	$DeckBuilder/PlayerInventory.create_inventory()
	$DeckBuilder/PlayerDeck.create_inventory()
	$DeckBuilder/CardManager.create_references()
	$"../Enemy".build_deck()
	
	cd_handler($DeckBuilder/CardManager.inventory_card_slot_reference)
	cd_handler($DeckBuilder/CardManager.deck_card_slot_reference)
	cd_handler($"../Enemy".deck)
	
	$"../player_inventory".visible = true
	get_tree().get_nodes_in_group("character")[0].inventory_screen_toggle(true)
	$"../ConsumableManger".visible = false
	$DeckBuilder/CardManager.inventory_toggle = true
	$DeckBuilder/CardManager.toggle_inventory()

func cd_handler(cards):
	for i in cards:
		if i == null: continue
		i.card_stats.cd_remaining -= 1
		if i.card_stats.cd_remaining <= 0: i.card_stats.on_cd = false
		i.update_card_ui()

func end_fight():
	$DeckBuilder/PlayerInventory.create_inventory()
	$DeckBuilder/PlayerDeck.create_inventory()
	$DeckBuilder/CardManager.create_references()
	$"../Enemy".build_deck()
	
	
	$"../player_inventory".visible = true
	get_tree().get_nodes_in_group("character")[0].inventory_screen_toggle(true)
	$"../ConsumableManger".visible = false
	$DeckBuilder/CardManager.inventory_toggle = true
	$DeckBuilder/CardManager.toggle_inventory()
	
	for i in get_tree().get_nodes_in_group("card"):
		i.card_stats.cd_remaining = 0
		i.card_stats.on_cd = false
		i.update_card_ui()
