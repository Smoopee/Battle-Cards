extends Node2D


func next_turn():
	$DeckBuilder/PlayerInventory.create_inventory()
	$DeckBuilder/PlayerDeck.create_inventory()
	$DeckBuilder/CardManager.create_references()
	
	$"../Player".visible = false
	$"../Player".process_mode = PROCESS_MODE_DISABLED
	
	$"../ConsumableManger".visible = false
	$"../ConsumableManger".process_mode = PROCESS_MODE_DISABLED
