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
	create_merchant_inventory()

func create_merchant_inventory():
	fetch_merchant_inventory()
	
	for i in range(inventory_db.size()):
		var card_scene = load(inventory_db[i].card_scene_path).instantiate()
		card_scene.set_stats()
		add_child(card_scene)
		add_card_to_hand(card_scene)
	
	var card_position = 0
	for i in inventory:
		i.get_node("Area2D").collision_mask = 64
		i.get_node("Area2D").collision_layer = 64
		i.update_card_ui()
		i.card_shop_ui()
		i.card_stats.inventory_position = card_position
		i.card_stats.is_players = false
		card_position += 1

func fetch_merchant_inventory():
	inventory_db = $"../Merchant".get_child(0).get_inventory()

func add_card_to_hand(card):
	if card not in inventory:
		inventory.push_back(card)
		update_hand_positions()
	else:
		animate_card_to_position(card, card.card_stats.screen_position)

func update_hand_positions():
	for i in range(inventory.size()):
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		var card = inventory[i]
		card.card_stats.screen_position = new_position
		card.position = new_position
 
func calculate_card_position(index):
	var more_space = 0
	if get_children().size() > 6:
		more_space = 30
	if get_children().size() > 12:
		more_space = 50
	var total_width = (inventory.size() - 1) * (CARD_WIDTH - more_space)
	var x_offset = center_screen_x + (index * (CARD_WIDTH - more_space)) - (total_width / 2)
	return x_offset

func remove_card_from_hand(card):
	if card in inventory:
		inventory.erase(card)
		update_hand_positions()

func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1)
