extends Node2D


@onready var player_inventory = $PlayerInventoryScreen
var screen_size


func _ready():
	get_tree().get_first_node_in_group("bottom ui").toggle_inventory(true)
	screen_size = get_viewport_rect().size
	$RewardSelection.reward_selection()

func inventory_and_deck_save():
	var temp_inventory = []
	for i in player_inventory.inventory_card_slot_reference:
		if i != null:
			temp_inventory.push_back(i.card_stats)
		else:
			temp_inventory.push_back(null)
	Global.player_inventory = temp_inventory

	var temp_deck = []
	for i in player_inventory.deck_card_slot_reference:
		if i != null:
			temp_deck.push_back(i.card_stats)
		else:
			temp_deck.push_back(null)
	Global.player_deck = temp_deck

func _on_continue_button_down():
	next_scene()

func next_scene():
	Global.current_scene = "intermission"
	inventory_and_deck_save()
	Global.player_consumables = get_tree().get_first_node_in_group("player consumables").get_consumable_array()
	Global.player_runes = get_tree().get_first_node_in_group("player runes").get_rune_array()
	Global.save_function()
	await get_tree().get_first_node_in_group("main").scene_transition(1, 1.0)
	get_parent().add_scene("res://Scenes/UI/Intermission/intermission.tscn")
	queue_free()
