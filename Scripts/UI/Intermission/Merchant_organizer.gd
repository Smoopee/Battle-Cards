extends Node2D

const CARD_SCENE_PATH = "res://Scenes/UI/card.tscn"
const CARD_WIDTH = 150
const MERCHANT_Y_POSITION = 590

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

	for i in range(0, 3):
		var merchant_pool_size = merchant_selection_array.size() - 1
		var selection = rng.randi_range(0, merchant_pool_size)
		var new_instance = load(merchant_db_reference.MERCHANTS[merchant_selection_array[selection]])
		merchant_array.push_front(new_instance)
		merchant_selection_array.remove_at(selection)
		
	create_encounter(merchant_array)

func create_encounter(merchant_array):
	var card = preload("res://Scenes/UI/card.tscn")
	
	for i in range(merchant_array.size()):
		var merchant_scene = card
		var new_merchant = merchant_scene.instantiate()
		new_merchant.get_node("CardImage").texture = load(merchant_array[i].merchant_art_path)
		new_merchant.get_node("Area2D").collision_layer = 2
		new_merchant.get_node("Area2D").collision_mask = 2
		new_merchant.card_resource = merchant_array[i]
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
