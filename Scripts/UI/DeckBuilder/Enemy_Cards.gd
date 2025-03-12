extends Node2D


const CARD_WIDTH = 130
const ENEMY_CARD_COLLISION_LAYER = 64
const HAND_Y_POSITION = 370
const CARD_SCENE_PATH = "res://Scenes/UI/card.tscn"


var enemy_cards_db = []
var enemy_inventory = []

var center_screen_x

func _ready():
	center_screen_x = get_viewport().size.x / 2
	create_enemy_cards()

func create_enemy_cards():
	fetch_enemy_cards()

	for i in range(enemy_cards_db.size()):
		var card_scene = load(enemy_cards_db[i].card_scene_path).instantiate()
		card_scene.card_stats = enemy_cards_db[i]
		add_child(card_scene)
		add_card_to_hand(card_scene)
	
	var card_position = 0
	for i in enemy_inventory:
		i.upgrade_card(i.card_stats.upgrade_level)
		i.update_card_ui()
		i.get_node("Area2D").collision_mask = ENEMY_CARD_COLLISION_LAYER
		i.get_node("Area2D").collision_layer = ENEMY_CARD_COLLISION_LAYER
		i.card_stats.inventory_position = card_position
		i.card_stats.is_players = false
		card_position += 1

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


