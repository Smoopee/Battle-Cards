extends Node2D

const CARD_WIDTH = 250
const HAND_Y_POSITION = 376

var inventory = []
var inventory_selection = []
var selected_inventory = []

var card_db_reference
var center_screen_x


func setup(card_tag):
	card_db_reference = preload("res://Resources/Cards/card_db.gd")
	center_screen_x = get_viewport().size.x / 2
	get_inventory(card_tag)
	get_tree().get_first_node_in_group("card selector").visible = false
	get_tree().get_first_node_in_group("card manager").toggle_inventory()
	get_tree().get_first_node_in_group("player cards").get_node("SellZone").visible = true


func get_inventory(card_tag):
	get_inventory_selection(card_tag)
	create_inventory()
	create_card_selection()

func get_inventory_selection(card_tag):
	for i in card_db_reference.ITEMS:
		var temp = load(card_db_reference.ITEMS[i])
		for j in temp.tags:
			if j == card_tag:
				inventory_selection.push_back(temp)

func create_inventory():
	for i in range(0, 4):
		var selection = random_item_selection().duplicate()
		inventory.push_front(selection)
	
	item_upgrade_function()
	
func random_item_selection():
	var rng = RandomNumberGenerator.new()
	
	var item_selection_index = rng.randi_range(0, inventory_selection.size()-1)
	return inventory_selection[item_selection_index]
	

func item_upgrade_function():
	var rng = RandomNumberGenerator.new()
	
	for i in inventory:
		var upgrade_calc = rng.randi_range(0, 99)
		if upgrade_calc >= 96: i.upgrade_level = 4
		elif upgrade_calc >= 69: i.upgrade_level = 3
		elif upgrade_calc >= 49: i.upgrade_level = 2
		elif upgrade_calc >= 0: i.upgrade_level = 1


#Display Cards ====================================================================================
func create_card_selection():

	for i in range(inventory.size()):
		var card_scene = load(inventory[i].card_scene_path).instantiate()
		card_scene.card_stats = inventory[i]
		get_tree().get_first_node_in_group("organizer").add_child(card_scene)
		add_card_to_hand(card_scene)
		card_scene.upgrade_card(card_scene.card_stats.upgrade_level)
	
	var card_position = 0
	for i in selected_inventory:
		i.get_node("Area2D").collision_mask = 64
		i.get_node("Area2D").collision_layer = 64
		i.card_stats.buy_price *= 2
		i.toggle_shop_ui(true)
		i.card_shop_ui()
		i.card_stats.inventory_position = card_position
		i.card_stats.is_players = false
		card_position += 1

func add_card_to_hand(card):
	if card not in selected_inventory:
		selected_inventory.push_back(card)
		update_hand_positions()
	else:
		animate_card_to_position(card, card.card_stats.screen_position)

func update_hand_positions():
	for i in range(selected_inventory.size()):
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		var card = selected_inventory[i]
		card.card_stats.screen_position = new_position
		card.position = new_position
 
func calculate_card_position(index):
	var more_space = 0
	if selected_inventory.size() > 6:
		more_space = 30
	if selected_inventory.size() > 12:
		more_space = 50
	var total_width = (selected_inventory.size() - 1) * (CARD_WIDTH - more_space)
	var x_offset = center_screen_x + (index * (CARD_WIDTH - more_space)) - (total_width / 2)
	return x_offset

func remove_card_from_hand(card):
	if card in selected_inventory:
		selected_inventory.erase(card)
		update_hand_positions()

func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1)
