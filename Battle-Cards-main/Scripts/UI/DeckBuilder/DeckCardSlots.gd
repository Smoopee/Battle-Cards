extends Node2D

const CARD_WIDTH = 160
const DECK_Y_POSITION = 600
const NUMBER_OF_DECKSLOTS = 10


var center_screen_x
var card_slot_array = []


func _ready():
	center_screen_x = get_viewport().size.x / 2
	var current_slot = NUMBER_OF_DECKSLOTS
	
	for i in range(0, NUMBER_OF_DECKSLOTS):
		var card_slot = load("res://Scenes/UI/card_slot.tscn").instantiate()
		add_child(card_slot)
		card_slot.change_slot_number(current_slot)
		current_slot -= 1
		add_card_to_hand(card_slot)

func add_card_to_hand(card_slot):
	card_slot_array.push_front(card_slot)
	update_hand_positions()

func update_hand_positions():
	for i in range(card_slot_array.size()):
		var new_position = Vector2(calculate_card_position(i), DECK_Y_POSITION)
		var card = card_slot_array[i]
		card.position = new_position

func calculate_card_position(index):
	var total_width = (card_slot_array.size() - 1) * CARD_WIDTH
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2
	return x_offset
