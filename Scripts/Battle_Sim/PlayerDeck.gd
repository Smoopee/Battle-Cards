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
	card_slot_reference = []
	clear_cards()
	fetch_inventory()
	
	var card_position = 0
	for i in range(deck_db.size()):
		if deck_db[i] == null:
			fill_card_slots(deck_db[i], card_position)
			card_position += 1
			continue
		var card_scene = load(deck_db[i].card_scene_path).instantiate()
		card_scene.card_stats = deck_db[i]
		add_child(card_scene)
		#card_scene.upgrade_card(card_scene.card_stats.upgrade_level)
		card_scene.update_card_ui()
		if reward_screen: card_scene.card_shop_ui()
		card_scene.card_stats.inventory_position = card_position
		card_scene.card_stats.is_players = true
		fill_card_slots(card_scene, card_position)
		card_position += 1
		
	while card_slot_reference.size() < NUMBER_OF_DECKSLOTS:
		card_slot_reference.push_back(null)
		

func clear_cards():
	for i in get_children():
		if i.is_in_group("card"):
			i.queue_free()

func fetch_inventory():
	if reward_screen == true: deck_db = Global.player_deck
	else: deck_db = Global.player_active_deck

func remove_card(card):
	if reward_screen == true: 
		if card in Global.player_deck:
			Global.player_deck.erase(card)
	else:
		if card in Global.active_player_deck:
			Global.player_active_deck.erase(card)

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

