extends Node2D

const CARD_WIDTH = 350
const CARD_Y_POSITION = 400

var center_screen_x
var selection_array = []
var selection = []

func _ready():
	center_screen_x = get_viewport().size.x / 2
	var invest5 = load("res://Scenes/UI/Town/TownEventScreens/Bank/Invest5.tscn")
	var invest10 = load("res://Scenes/UI/Town/TownEventScreens/Bank/Invest10.tscn")
	var invest20 = load("res://Scenes/UI/Town/TownEventScreens/Bank/Invest20.tscn")
	var invest40 = load("res://Scenes/UI/Town/TownEventScreens/Bank/Invest40.tscn")
	
	selection_array = [invest5, invest10, invest20, invest40]
	create_encounter()

func create_encounter():
	for i in range(selection_array.size()):
		var new_selection = selection_array[i].instantiate()
		add_child(new_selection)
		selection.push_back(new_selection)
		update_card_positions()

func update_card_positions():
	for i in range(selection.size()):
		var new_position = Vector2(calculate_card_position(i), CARD_Y_POSITION)
		var card = selection[i]
		card.position = new_position
 
func calculate_card_position(index):
	var total_width = (selection.size() - 1) * CARD_WIDTH
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2
	return x_offset
