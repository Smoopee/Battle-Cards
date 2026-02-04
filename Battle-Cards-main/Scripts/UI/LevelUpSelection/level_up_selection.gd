extends Node2D


@onready var player_inventory = get_tree().get_first_node_in_group("player cards")
var screen_size

var is_reward_setup = false
var is_reward_chosen = false

func _ready():
	get_tree().get_first_node_in_group("character ui").toggle_inventory(true)
	screen_size = get_viewport_rect().size
	$HeaderPanel.position.x = screen_size.x /2 - $HeaderPanel.size.x /2
	$HeaderPanel.position.y = 100
	$RewardSelection.reward_selection()
	is_reward_setup = true

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
	is_reward_chosen = true
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

func _on_reward_chosen() -> void:
	if is_reward_setup and not is_reward_chosen: 
		is_reward_chosen = true
		next_scene()
