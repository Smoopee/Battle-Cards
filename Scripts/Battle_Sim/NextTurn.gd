extends Node2D


func next_turn():
	$DeckBuilder/PlayerInventory.create_inventory()
	$DeckBuilder/PlayerDeck.create_inventory()
	$DeckBuilder/CardManager.create_references()
