extends Node2D


const CARD_WIDTH = 130
const HAND_Y_POSITION = 690
const CARD_SCENE_PATH = "res://Scenes/UI/card.tscn"

var card_db_reference
var inventory_db = []
var inventory = []

var center_screen_x

func _ready():
	center_screen_x = get_viewport().size.x / 2
	card_db_reference = preload("res://Resources/Cards/card_db.gd")
	create_inventory()

func create_inventory():
	fetch_inventory()
	
	var card = preload("res://Scenes/UI/card.tscn")
	var card_position = 0
	for i in range(inventory_db.size()):
		var card_scene = card
		var new_card = card_scene.instantiate()
		new_card.card_resource = inventory_db[i].duplicate()
		new_card.card_resource.inventory_position = card_position
		new_card.card_resource.is_players = true
		$"../CardManager".add_child(new_card)
		new_card.update_card_ui()
		new_card.card_shop_ui()
		add_card_to_hand(new_card)
		card_position += 1
	
func fetch_inventory():
	inventory_db = Global.player_inventory

func add_card_to_hand(card):
	if card not in inventory:
		inventory.push_back(card)
		update_hand_positions()
	else:
		animate_card_to_position(card, card.card_resource.screen_position)

func update_hand_positions():
	for i in range(inventory.size()):
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		var card = inventory[i]
		card.card_resource.screen_position = new_position
		card.position = new_position
 
func calculate_card_position(index):
	var total_width = (inventory.size() - 1) * CARD_WIDTH
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2
	return x_offset
 
func remove_card_from_hand(card):
	if card in inventory:
		inventory.erase(card)
		update_hand_positions()

func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1)
