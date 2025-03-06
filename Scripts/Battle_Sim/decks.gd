extends Node2D


const CARD_WIDTH = 130
const DECK_Y_POSITION = 900
const DECK_X_POSITION = 650
const CARD_SCENE_PATH = "res://Scenes/UI/card.tscn"

var card_db_reference
var deck_db = []
var deck = []
var center_screen_x
var center_screen_y
var discard_offset = 0


func _ready():
	center_screen_x = get_viewport().size.x / 2
	center_screen_y = get_viewport().size.y / 2
	card_db_reference = preload("res://Resources/Cards/card_db.gd")

func build_deck():
	deck_db = Global.player_deck
	
	var counter = 0
	
	var card = preload("res://Scenes/UI/card.tscn")
	var card_position = 0
	for i in range(deck_db.size()):
		var card_scene = card
		var new_card = card_scene.instantiate()
		add_child(new_card)
		deck.push_back(new_card)
		var new_node = load(deck_db[i].card_scene_path).instantiate()
		get_child(i).add_child(new_node)
		new_card.card_resource = deck_db[i]
		new_node.upgrade_card(deck_db[i].upgrade_level)
		new_node.item_enchant(deck_db[i].item_enchant)
		new_card.card_resource = deck_db[i].duplicate()
		new_card.card_resource.is_players = true
		new_card.card_resource.deck_position = counter
		new_card.update_card_ui()
		counter += 1
		
	for i in deck:
		i.get_child(3).upgrade_card(i.card_resource.upgrade_level)
	
	return deck


func build_deck_position():
	for i in deck:
		discard_offset = 0
		i.is_discarded = false
		i.scale =  Vector2(1, 1)
		i.position = Vector2(DECK_X_POSITION, DECK_Y_POSITION)
 
func play_card(card):
	if card.card_resource.deck_position < deck.size()-1:
		deck[card.card_resource.deck_position+1].z_index = 3
	animate_card_to_active_position(card)

func animate_card_to_active_position(card):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", Vector2(center_screen_x, center_screen_y + 150), 0.2)

func discard(card):
	card.is_discarded = true
	card.z_index = 1
	card.scale = Vector2(.55, .55)
	animate_card_to_discard_position(card)

func animate_card_to_discard_position(card):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", Vector2(1250 - discard_offset, 900), 0.1)
	discard_offset += 20
