extends Node2D


const CARD_WIDTH = 130
const DECK_Y_POSITION = 760
const DECK_X_POSITION = 600

var deck_db = []
var deck = []
var center_screen_x
var center_screen_y
var discard_offset = 0
var deck_offset = 0
var first_test = true

func _ready():
	center_screen_x = get_viewport().size.x / 2
	center_screen_y = get_viewport().size.y / 2

func initial_build_deck():
	discard_offset = 0
	deck_offset = 0
	clear_cards()
	deck = []
	deck_db = Global.player_active_deck
	
	var counter = 0
	
	for i in range(deck_db.size()):
		var new_card = load(deck_db[i].card_scene_path).instantiate()
		add_child(new_card)
		deck.push_back(new_card)
		new_card.card_stats = deck_db[i]
		if first_test: new_card.upgrade_card(new_card.card_stats.upgrade_level)
		new_card.item_enchant(new_card.card_stats.item_enchant)
		new_card.card_stats.card_owner = get_tree().get_first_node_in_group("character")
		new_card.card_stats.is_players = true
		new_card.card_stats.deck_position = counter
		counter += 1
	
	first_test = false
	return deck

func clear_cards():
	for i in get_children():
		if i.is_in_group("card"):
			i.queue_free()

func build_deck_position():
	discard_offset = 0
	deck_offset = 0
	var temp_z_index = 13
	for i in deck:
		i.card_stats.is_discarded = false
		i.scale =  Vector2(1, 1)
		i.position = Vector2(DECK_X_POSITION + deck_offset, DECK_Y_POSITION)
		i.z_index = temp_z_index
		deck_offset -= 40
		temp_z_index -= 1
 
func build_deck():
	var blank = load("res://Resources/Cards/blank.tres")
	var counter = 0
	deck = []
	var card_position = 0
	for i in $"../NextTurn/DeckBuilder/CardManager".deck_card_slot_reference:
		if i == null:
			var load_blank = load("res://Scenes/Cards/blank_card.tscn").instantiate()
			load_blank.card_stats = blank
			load_blank.card_stats.deck_position = counter
			load_blank.card_stats.card_owner = get_tree().get_first_node_in_group("character")
			load_blank.card_stats.is_players = true
			deck.push_back(load_blank)
			add_child(load_blank)
		else:
			deck.push_back(i)
			i.reparent(self)
			i.card_stats.deck_position = counter
			
		counter += 1
	return deck

func play_card(card):
	animate_card_to_active_position(card)

func animate_card_to_active_position(card):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", Vector2(center_screen_x, center_screen_y + 87), 0.2 * Global.COMBAT_SPEED)
	await tween.finished

func discard(card):
	card.card_stats.is_discarded = true
	card.z_index = 1
	card.scale = Vector2(.55, .55)
	animate_card_to_discard_position(card)

func animate_card_to_discard_position(card):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", Vector2(1450 - discard_offset, 790), 0.1 * Global.COMBAT_SPEED)
	await tween.finished
	discard_offset += 20
