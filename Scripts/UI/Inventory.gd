extends Node2D


const CARD_WIDTH = 150
const HAND_Y_POSITION = 890
const CARD_SCENE_PATH = "res://Scenes/UI/card.tscn"

var rock = preload("res://Resources/Cards/rock.tres")
var dagger = preload("res://Resources/Cards/dagger.tres")
var strengthen = preload("res://Resources/Cards/strengthen.tres")

var inventory_db = []
var inventory = []

var center_screen_x


func _ready():
	center_screen_x = get_viewport().size.x / 2
	
	fetch_inventory()
	
	var card = preload("res://Scenes/UI/card.tscn")
	
	for i in range(inventory_db.size()):
		var card_scene = card
		var new_card = card_scene.instantiate()
		new_card.get_node("CardImage").texture = load(inventory_db[i].card_art_path)
		new_card.card_name = inventory_db[i].name
		new_card.path = inventory_db[i].card_scene_path
		$"../CardManager".add_child(new_card)
		add_card_to_hand(new_card)

func fetch_inventory():
	inventory_db = [strengthen, dagger, rock, dagger, dagger, rock, rock, rock, dagger, rock, dagger, dagger]

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
