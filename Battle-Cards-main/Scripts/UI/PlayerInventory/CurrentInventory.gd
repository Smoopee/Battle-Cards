extends Node2D


const CARD_WIDTH = 130
const HAND_Y_POSITION = 730

var number_of_slots
var inventory_db = []
var inventory = []

var card_slot_reference = []
var card_slot_array = []

var center_screen_x
var animation_cancel = true


func _ready():
	number_of_slots = Global.number_of_inventory_slots
	center_screen_x = get_viewport().size.x / 2
	
	for i in $"../InventorySlots".get_children():
		card_slot_array.push_front(i)
		
	create_inventory()
	while card_slot_reference.size() < number_of_slots:
		card_slot_reference.push_back(null)
		
	animation_cancel = false
	
func create_inventory():
	fetch_inventory()
	
	var card_position = 0
	for i in range(inventory_db.size()):
		if inventory_db[i] == null:
			fill_card_slots(inventory_db[i], card_position)
			card_position += 1
			continue
		var card_scene 
		card_scene = load(inventory_db[i].card_scene_path).instantiate()
		card_scene.card_stats = inventory_db[i]
		add_child(card_scene)
		card_scene.get_node("BaseCard").upgrade_card(card_scene.card_stats.upgrade_level)
		card_scene.get_node("BaseCard").update_card_ui()
		card_scene.card_stats.inventory_position = card_position
		card_scene.card_stats.is_players = true
		fill_card_slots(card_scene, card_position)
		card_position += 1


func fetch_inventory(inventory = Global.player_inventory):
	inventory_db = inventory

func calculate_card_position(index):
	var total_width = (inventory.size() - 1) * CARD_WIDTH
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2
	return x_offset

func remove_card(card):
	if card in Global.player_inventory:
		Global.player_inventory.erase(card)

func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, .1)

func fill_card_slots(new_card, index):
	card_slot_reference.push_back(new_card)
	if new_card == null: 
		card_slot_array[index].card_in_slot = false
		return
	new_card.position = card_slot_array[index].position
	card_slot_array[index].card_in_slot = true
