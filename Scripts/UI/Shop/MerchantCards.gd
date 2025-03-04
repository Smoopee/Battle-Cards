extends Node2D


const CARD_WIDTH = 150
const HAND_Y_POSITION = 300
const CARD_SCENE_PATH = "res://Scenes/UI/card.tscn"

var inventory_db = []
var inventory = []

var center_screen_x

var animation_canel = true

func _ready():
	center_screen_x = get_viewport().size.x / 2
	
	fetch_merchant_inventory()
	
	var card = preload("res://Scenes/UI/card.tscn")
	
	for i in range(inventory_db.size()):
		var card_scene = card
		var new_card = card_scene.instantiate()
		new_card.get_node("Area2D").collision_layer = 2
		new_card.get_node("Area2D").collision_mask = 2
		new_card.card_resource = inventory_db[i].duplicate()
		$"../CardManager".add_child(new_card)
		new_card.update_card_ui()
		add_card_to_hand(new_card)

func fetch_merchant_inventory():
	inventory_db = $"../Merchant".get_child(0).get_inventory()

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
		if animation_canel:
			card.position = new_position
		else:
			animate_card_to_position(card, new_position)
 
func calculate_card_position(index):
	var total_width = (inventory.size() - 1) * CARD_WIDTH
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2
	return x_offset
 
func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1)

func remove_card_from_hand(card):
	if card in inventory:
		inventory.erase(card)
		update_hand_positions()
