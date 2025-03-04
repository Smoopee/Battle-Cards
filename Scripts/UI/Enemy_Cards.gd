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
		add_child(new_card)
		var new_node = load(enemy_cards_db[i].card_scene_path).instantiate()
		get_child(i).add_child(new_node)
		new_card.card_resource = enemy_cards_db[i].duplicate()
		new_node.upgrade_card(enemy_cards_db[i].upgrade_level)
		new_card.card_resource.is_players = false
		new_card.card_resource.in_enemy_deck = true
		new_card.card_resource.inventory_position = card_position
		new_card.update_card_ui()
		new_node.queue_free()
		
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
		card.card_resource.screen_position = new_position
		card.position = new_position
 
func calculate_card_position(index):
	var total_width = (enemy_inventory.size() - 1) * CARD_WIDTH
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2
	return x_offset


