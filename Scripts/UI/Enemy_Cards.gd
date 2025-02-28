extends Node2D


const CARD_WIDTH = 130
const HAND_Y_POSITION = 370
const CARD_SCENE_PATH = "res://Scenes/UI/card.tscn"

var card_db_reference
var enemy_cards_db = []
var enemy_inventory = []

var center_screen_x

func _ready():
	center_screen_x = get_viewport().size.x / 2
	card_db_reference = preload("res://Resources/Cards/card_db.gd")
	create_enemy_cards()

func create_enemy_cards():
	fetch_enemy_cards()
	
	var card = preload("res://Scenes/UI/card.tscn")
	var card_position = 0
	for i in range(enemy_cards_db.size()):
		var card_scene = card
		var new_card = card_scene.instantiate()
		new_card.get_node("CardImage").texture = load(enemy_cards_db[i].card_art_path)
		new_card.card_name = enemy_cards_db[i].name
		new_card.card_scene_path = enemy_cards_db[i].card_scene_path
		new_card.card_position = card_position
		new_card.is_players = false
		add_child(new_card)
		add_card_to_hand(new_card)
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
		card.hand_position = new_position
		card.position = new_position
 
func calculate_card_position(index):
	var total_width = (enemy_inventory.size() - 1) * CARD_WIDTH
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2
	return x_offset


