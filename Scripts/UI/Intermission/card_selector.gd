extends Node2D


const CARD_WIDTH = 150
const HAND_Y_POSITION = 890
const CARD_SCENE_PATH = "res://Scenes/UI/card.tscn"

@onready var intermission = $".."

var inventory_db = []
var inventory = []

var center_screen_x


func _ready():
	center_screen_x = get_viewport().size.x / 2
	
	var card = preload("res://Scenes/UI/card.tscn")
	var card_scene = card
	var new_card = card_scene.instantiate()
	new_card.get_node("CardImage").texture = load("res://Resources/Art/UIElements/pointer.png")
	intermission.call_deferred("add_child", new_card)
	add_card_to_hand(new_card)


func add_card_to_hand(card):
	if card not in inventory:
		inventory.insert(0, card)
		update_hand_positions()
	else:
		animate_card_to_position(card, card.hand_position)

func update_hand_positions():
	for i in range(inventory.size()):
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		var card = inventory[i]
		card.hand_position = new_position
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
