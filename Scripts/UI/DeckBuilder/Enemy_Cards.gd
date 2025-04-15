extends Node2D

signal build_enemy_deck

const CARD_WIDTH = 160
const ENEMY_CARD_COLLISION_LAYER = 64
const HAND_Y_POSITION = 376


var enemy_cards_db = []
var enemy_inventory = []

var center_screen_x

func _ready():
	center_screen_x = get_viewport().size.x / 2
	create_enemy_cards()

func create_enemy_cards():
	fetch_enemy_cards()
	
	var counter = 0
	var blank = load("res://Resources/Cards/blank.tres")
	for i in range(enemy_cards_db.size()):
		if enemy_cards_db[i] == null:
			var load_blank = load("res://Scenes/Cards/blank_card.tscn").instantiate()
			load_blank.card_stats = blank
			load_blank.card_stats.deck_position = counter
			load_blank.card_stats.card_owner = get_tree().get_first_node_in_group("character")
			load_blank.card_stats.in_enemy_deck = true
			load_blank.card_stats.is_players = false
			add_card_to_hand(load_blank)
			add_child(load_blank)
		else:
			var card_scene = load(enemy_cards_db[i].card_scene_path).instantiate()
			card_scene.card_stats = enemy_cards_db[i]
			card_scene.upgrade_card(card_scene.card_stats.upgrade_level)
			card_scene.update_card_ui()
			card_scene.get_node("Area2D").collision_mask = ENEMY_CARD_COLLISION_LAYER
			card_scene.get_node("Area2D").collision_layer = ENEMY_CARD_COLLISION_LAYER
			card_scene.card_stats.inventory_position = counter
			card_scene.card_stats.in_enemy_deck = true
			card_scene.card_stats.is_players = false
			add_card_to_hand(card_scene)
			add_child(card_scene)
			
		counter += 1
		
	emit_signal("build_enemy_deck")
	
func fetch_enemy_cards():
	enemy_cards_db = $"../Enemy".enemy_deck

func add_card_to_hand(card):
	enemy_inventory.push_back(card)
	update_hand_positions()

func update_hand_positions():
	for i in range(enemy_inventory.size()):
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		var card = enemy_inventory[i]
		card.card_stats.screen_position = new_position
		card.position = new_position
 
func calculate_card_position(index):
	var total_width = (enemy_inventory.size() - 1) * CARD_WIDTH
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2
	return x_offset


