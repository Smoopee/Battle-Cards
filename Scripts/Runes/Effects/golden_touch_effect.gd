extends Node2D

const ENEMY_CARD_COLLISION_LAYER = 64
var one_shot = true

func _ready():
	if get_tree().get_first_node_in_group("enemy deck") != null:
		get_tree().get_first_node_in_group("enemy deck").connect("build_enemy_deck", rune_effect1)

	if get_tree().get_first_node_in_group("enemy") != null:
		if get_tree().get_first_node_in_group("enemy").has_signal("generate_reward"):
			get_tree().get_first_node_in_group("enemy").connect("generate_reward", reward)


func rune_effect1():
	if one_shot == false: return
	var enemy_deck = get_tree().get_first_node_in_group("enemy deck").deck
	var golden_touch_card = load("res://Scenes/Cards/golden_touch.tscn").instantiate().duplicate()
	var rng = RandomNumberGenerator.new()
	var rng_selection = rng.randi_range(0, enemy_deck.size()-1)
	
	get_tree().get_first_node_in_group("enemy deck").add_child(golden_touch_card)
	golden_touch_card.card_stats = load("res://Resources/Cards/golden_touch.tres")
	golden_touch_card.get_node("Area2D").collision_mask = ENEMY_CARD_COLLISION_LAYER
	golden_touch_card.get_node("Area2D").collision_layer = ENEMY_CARD_COLLISION_LAYER
	golden_touch_card.upgrade_card(golden_touch_card.card_stats.upgrade_level)
	golden_touch_card.card_stats.in_enemy_deck = true
	golden_touch_card.card_stats.owner = get_tree().get_first_node_in_group("enemy")
	golden_touch_card.card_stats.is_players = false
	
	var selected_card = enemy_deck[rng_selection]
	enemy_deck[rng_selection] = golden_touch_card
	golden_touch_card.card_stats.deck_position = selected_card.card_stats.deck_position
	get_tree().get_first_node_in_group("enemy deck").update_hand_positions()
	selected_card.queue_free()
	
	one_shot = false

func reward():
	pass
