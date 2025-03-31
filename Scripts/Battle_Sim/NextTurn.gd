extends Node2D


func next_turn():
	$DeckBuilder/PlayerInventory.create_inventory()
	$DeckBuilder/PlayerDeck.create_inventory()
	$DeckBuilder/CardManager.create_references()
	
	get_tree().get_nodes_in_group("character")[0].inventory_screen_toggle(true)
	#$"../Player".process_mode = PROCESS_MODE_DISABLED
	
	$"../ConsumableManger".visible = false
	#$"../ConsumableManger".process_mode = PROCESS_MODE_DISABLED
	
	for i in $DeckBuilder/CardManager.inventory_card_slot_reference:
		if i == null: continue
		i.card_stats.cd_remaining -= 1
		if i.card_stats.cd_remaining <= 0: i.card_stats.on_cd = false
		i.update_card_ui()
	
	for i in $DeckBuilder/CardManager.deck_card_slot_reference:
		if i == null: continue
		i.card_stats.cd_remaining -= 1
		if i.card_stats.cd_remaining <= 0: i.card_stats.on_cd = false
		i.update_card_ui()
	
	for i in $"../Enemy".deck:
		if i == null: continue
		i.card_stats.cd_remaining -= 1
		if i.card_stats.cd_remaining <= 0: i.card_stats.on_cd = false
		i.update_card_ui()
