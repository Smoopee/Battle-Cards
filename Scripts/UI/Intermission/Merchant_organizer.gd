extends Node2D

const CARD_WIDTH = 350
const MERCHANT_Y_POSITION = 400

var number_of_merchants = 3

var rng = RandomNumberGenerator.new()
var merchant_db_reference
var center_screen_x
var merchant_array = []
var merchant_selection = []


func _ready():
	center_screen_x = get_viewport().size.x / 2
	merchant_db_reference = preload("res://Resources/Merchants/merchant_db.gd")
	
	var merchant_selection_array = []
	for i in merchant_db_reference.MERCHANTS:
		merchant_selection_array.push_front(i)

	for i in range(0, number_of_merchants):
		var merchant_pool_size = merchant_selection_array.size() - 1
		var selection = rng.randi_range(0, merchant_pool_size)
		var new_instance = load(merchant_db_reference.MERCHANTS[merchant_selection_array[selection]])
		merchant_array.push_front(new_instance)
		merchant_selection_array.remove_at(selection)
	
	if Global.intermission_tracker == 0:
		var town = load("res://Resources/Merchants/go_to_town.tres")
		merchant_array.push_front(town)
	if Global.intermission_tracker >= 1:
		var camp = load("res://Resources/Merchants/camp.tres")
		merchant_array.push_front(camp)
	
	create_encounter()

func create_encounter():
	for i in range(merchant_array.size()):
		var merchant_resource = merchant_array[i]
		var new_merchant = load(merchant_resource.merchant_scene_path).instantiate()
		new_merchant.merchant_stats = merchant_resource
		add_child(new_merchant)
		merchant_selection.push_front(new_merchant)
		update_merchant_positions()

func update_merchant_positions():
	for i in range(merchant_selection.size()):
		var new_position = Vector2(calculate_card_position(i), MERCHANT_Y_POSITION)
		var merchant = merchant_selection[i]
		merchant.position = new_position
 
func calculate_card_position(index):
	var total_width = (merchant_selection.size() - 1) * CARD_WIDTH
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2
	return x_offset
