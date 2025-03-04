extends Node2D


const CARD_WIDTH = 130
const HAND_Y_POSITION = 690
const CARD_SCENE_PATH = "res://Scenes/UI/card.tscn"

var card_db_reference
var deck_db = []
var deck = []


func _ready():
	card_db_reference = preload("res://Resources/Cards/card_db.gd")

func build_deck():
	deck_db = Global.player_deck
	
	var counter = 0
	
	var card = preload("res://Scenes/UI/card.tscn")
	var card_position = 0
	for i in range(deck_db.size()):
		var card_scene = card
		var new_card = card_scene.instantiate()
		new_card.get_node("CardImage").texture = load(deck_db[i].card_art_path)
		new_card.visible = false
		add_child(new_card)
		deck.push_back(new_card)
		var new_node = load(deck_db[i].card_scene_path).instantiate()
		new_node.visible = false
		get_child(i).add_child(new_node)
		new_card.card_resource = deck_db[i]
		new_node.upgrade_card(deck_db[i].upgrade_level)
		new_node.item_enchant(deck_db[i].item_enchant)
		new_card.card_resource = deck_db[i].duplicate()
		new_card.card_resource.is_players = true
		new_card.hand_position = counter
		counter += 1
	
	for i in deck:
		i.get_child(3).upgrade_card(i.card_resource.upgrade_level)
	
	return deck
	
