extends Node2D


const CARD_WIDTH = 130
const HAND_Y_POSITION = 530
const CARD_SCENE_PATH = "res://Scenes/UI/card.tscn"
var is_hoovering_on_card

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
		new_card.card_resource = inventory_db[i]
		new_card.card_resource.inventory_position = card_position
		new_card.card_resource.is_players = true
		new_card.update_card_ui()
		add_child(new_card)
		add_card_to_hand(new_card)
		card_position += 1
		
func fetch_inventory():
	inventory_db = Global.player_inventory

func add_card_to_hand(card):
	inventory.push_back(card)
	update_hand_positions()

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
 
func connect_card_signals(card):
	card.connect("hoovered", on_hoovered_over_card)
	card.connect("hoovered_off", on_hoovered_off_card)

func on_hoovered_over_card(card):
	if card.is_discarded == true:
		return
	if !is_hoovering_on_card:
		is_hoovering_on_card = true
		highlight_card(card, true)

func on_hoovered_off_card(card):
	is_hoovering_on_card = false

func highlight_card(card, hoovered):
	if hoovered:
		card.scale = Vector2(1.05, 1.05)
		card.z_index = 2
	else:
		card.scale = Vector2(1, 1)
		card.z_index = 1
