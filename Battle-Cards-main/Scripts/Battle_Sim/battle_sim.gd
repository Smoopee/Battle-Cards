extends Node2D

var is_toggle_inventory = true

func _ready():
	$NextTurn.initial_build()
	get_tree().get_first_node_in_group("character").inventory_screen_toggle(true)

func _input(event):
	if event.is_action_pressed("Inventory"):
		toggle_inventory()

func toggle_inventory():
	var player_cards = get_tree().get_first_node_in_group("player cards")
	var character = get_tree().get_first_node_in_group("character")
	
	#From player screen to Inventory
	if is_toggle_inventory == true:
		player_cards.visible = true
		character.inventory_screen_toggle(true)
		player_cards.process_mode = Node.PROCESS_MODE_INHERIT
		is_toggle_inventory = false
	#From Inventory to Player Screen
	else:
		player_cards.visible = false
		character.inventory_screen_toggle(false)
		player_cards.process_mode = Node.PROCESS_MODE_DISABLED
		is_toggle_inventory = true
