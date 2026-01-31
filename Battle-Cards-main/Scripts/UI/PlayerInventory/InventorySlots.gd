extends Node2D

const CARD_WIDTH = 160

var center_screen_x
var inventory_y_position: int
var card_slot_array = []
var number_of_slots

func _ready():
	center_screen_x = get_viewport().size.x / 2
	number_of_slots = Global.number_of_inventory_slots
	positioning()
	
	for i in range(0, number_of_slots):
		var card_slot = load("res://Scenes/UI/card_slot.tscn").instantiate()
		add_child(card_slot)
		card_slot.change_slot_number(number_of_slots)
		number_of_slots -= 1
		card_slot.get_node("Area2D").collision_mask = 4
		card_slot.get_node("Area2D").collision_layer = 4
		add_card_to_hand(card_slot)


func positioning():
	inventory_y_position = get_viewport().size.y - 195

func add_card_to_hand(card_slot):
	card_slot_array.push_front(card_slot)
	update_hand_positions()

func update_hand_positions():
	for i in range(card_slot_array.size()):
		var new_position = Vector2(calculate_card_position(i), inventory_y_position)
		var card = card_slot_array[i]
		card.position = new_position

func calculate_card_position(index):
	var total_width = (card_slot_array.size() - 1) * CARD_WIDTH * Global.ui_scaler.x 
	var x_offset = center_screen_x + index * CARD_WIDTH * Global.ui_scaler.x  - total_width / 2
	return x_offset
