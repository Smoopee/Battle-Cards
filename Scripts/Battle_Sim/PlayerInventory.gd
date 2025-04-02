extends Node2D


const CARD_WIDTH = 130
const HAND_Y_POSITION = 730
const NUMBER_OF_INVENTORY_SLOTS = 5

var inventory_db = []
var inventory = []

var card_slot_reference = []
var card_slot_array = []

var center_screen_x
var animation_cancel = true
var reward_screen = false


func _ready():
	center_screen_x = get_viewport().size.x / 2
	
	for i in $"../InventorySlots".get_children():
		card_slot_array.push_front(i)

func create_inventory():
	card_slot_reference = []
	fetch_inventory()
	
	var card_position = 0
	for i in inventory_db:
		if inventory_db[card_position] == null:
			fill_card_slots(inventory_db[card_position], card_position)
			card_position += 1
			continue

		i.enable_collision()
		i.card_stats.is_discarded = false
		i.z_index = 1
		i.scale = Vector2(1, 1)
		i.update_card_ui()
		if reward_screen: i.card_shop_ui()
		i.card_stats.inventory_position = card_position
		fill_card_slots(i, card_position)
		card_position += 1
		
	while card_slot_reference.size() < NUMBER_OF_INVENTORY_SLOTS:
		card_slot_reference.push_back(null)
	
func fetch_inventory():
	inventory_db = $"../../../player_inventory".inventory

func clear_cards():
	for i in get_children():
		if i.is_in_group("card"):
			i.queue_free()

func remove_card(card):
	if reward_screen == true:
		if card in Global.player_inventory:
			Global.player_inventory.erase(card)
	else:
		if card in Global.player_active.inventory:
			Global.player_active.inventory.erase(card)

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
