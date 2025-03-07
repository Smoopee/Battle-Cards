extends Node2D


const CARD_WIDTH = 130
const DECK_Y_POSITION = 900
const DECK_X_POSITION = 650

var card_db_reference
var deck_db = []
var deck = []
var center_screen_x
var center_screen_y
var discard_offset = 0


func _ready():
	center_screen_x = get_viewport().size.x / 2
	center_screen_y = get_viewport().size.y / 2

func build_deck():
	deck_db = Global.player_deck
	
	var counter = 0
	
	var card_position = 0
	for i in range(deck_db.size()):
		var new_card = load(deck_db[i].card_scene_path).instantiate()
		add_child(new_card)
		deck.push_back(new_card)
		new_card.card_stats = deck_db[i]
		new_card.upgrade_card(new_card.card_stats.upgrade_level)
		new_card.item_enchant(new_card.card_stats.item_enchant)
		new_card.card_stats.is_players = true
		new_card.card_stats.deck_position = counter
		new_card.update_card_ui()
		counter += 1
	
	return deck

func build_deck_position():
	for i in deck:
		discard_offset = 0
		i.card_stats.is_discarded = false
		i.scale =  Vector2(1, 1)
		i.position = Vector2(DECK_X_POSITION, DECK_Y_POSITION)
 
func play_card(card):
	if card.card_stats.deck_position < deck.size()-1:
		deck[card.card_stats.deck_position+1].z_index = 3
	animate_card_to_active_position(card)

func animate_card_to_active_position(card):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", Vector2(center_screen_x, center_screen_y + 150), 0.2)

func discard(card):
	card.card_stats.is_discarded = true
	card.z_index = 1
	card.scale = Vector2(.55, .55)
	animate_card_to_discard_position(card)

func animate_card_to_discard_position(card):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", Vector2(1250 - discard_offset, 900), 0.1)
	discard_offset += 20
