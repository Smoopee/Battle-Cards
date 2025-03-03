extends Node2D

const CARD_WIDTH = 130
const HAND_Y_POSITION = 550

var card_db_reference


var center_screen_x
var card_slot_array = []

func _ready():
	center_screen_x = get_viewport().size.x / 2
	
	for i in range(0, 10):
		var card_slot = load("res://Scenes/UI/card_slot.tscn").instantiate()
		add_child(card_slot)
		add_card_to_hand(card_slot)

func add_card_to_hand(card_slot):
	card_slot_array.push_front(card_slot)
	update_hand_positions()

func update_hand_positions():
	for i in range(card_slot_array.size()):
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		var card = card_slot_array[i]
		card.position = new_position

func calculate_card_position(index):
	var total_width = (card_slot_array.size() - 1) * CARD_WIDTH
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2
	return x_offset

