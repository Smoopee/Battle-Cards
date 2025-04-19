extends Node2D

const NUMBER_OF_DECKSLOTS = 10

var deck_db = []
var deck = []

var card_slot_reference = []
var card_slot_array = []

var center_screen_x
var animation_cancel = true
var reward_screen = false


func _ready():
	center_screen_x = get_viewport().size.x / 2
	
	for i in $"../DeckCardSlots".get_children():
		card_slot_array.push_front(i)

func create_inventory():
	var blank = load("res://Resources/Cards/blank.tres")
	card_slot_reference = []
	fetch_inventory()
	
	var card_position = 0
	
	
	for i in deck_db:
		if i == null:
			fill_card_slots(null, card_position)
			card_position += 1
			continue
		if i.card_stats == blank:
			fill_card_slots(null, card_position)
			card_position += 1
			i.queue_free()
			
			
		else:
			i.enable_collision()
			i.card_stats.is_discarded = false
			i.z_index = 1
			i.scale = Vector2(1, 1)
			i.update_card_ui()
			if reward_screen: i.card_shop_ui()
			i.card_stats.deck_position = card_position
			fill_card_slots(i, card_position)
			card_position += 1
		
	while card_slot_reference.size() < NUMBER_OF_DECKSLOTS:
		card_slot_reference.push_back(null)


func clear_cards():
	for i in get_children():
		if i.is_in_group("card"):
			i.queue_free()

func fetch_inventory():
	deck_db = get_tree().get_first_node_in_group("battle sim").player_deck_list

func remove_card(card):
	if card in Global.player_deck:
		Global.player_deck.erase(card)


func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1)

func fill_card_slots(new_card, index):
	card_slot_reference.push_back(new_card)
	if new_card == null: 
		card_slot_array[index].card_in_slot = false
		return
	new_card.position = card_slot_array[index].position
	card_slot_array[index].card_in_slot = true

