extends Node2D

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_MERCHANT_CARD = 64
const COLLISION_MASK_MERCHANT = 32
const COLLISION_MASK_PLAYER = 8
const COLLISION_MASK_DECK_SLOT = 2
const COLLISION_MASK_INVENTORY_SLOT = 4


var screen_size
var card_being_dragged
var merchant_inventory_reference
var deck_reference
var inventory_reference

var hover_on_upgrade_test = true
var upgrade_mode = false
var card_previous_position
var deck_card_slot_array = []
var deck_card_slot_reference = []
var inventory_card_slot_array = []
var inventory_card_slot_reference = []

var deck_card_slot_index 
var deck_card_slot_reference_index
var inventory_card_slot_index
var inventory_card_slot_reference_index
var previous_card_slot

func _ready():
	screen_size = get_viewport_rect().size
	merchant_inventory_reference = $"../CardSelectionCreator"
	
	inventory_card_slot_reference = $"../PlayerInventoryScreen".inventory_card_slot_reference
	deck_card_slot_reference = $"../PlayerInventoryScreen".deck_card_slot_reference
	
	inventory_card_slot_array = $"../PlayerInventoryScreen".inventory_card_slot_array
	deck_card_slot_array =  $"../PlayerInventoryScreen".deck_card_slot_array


func _process(delta):
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), 
			clamp(mouse_pos.y, 0, screen_size.y))

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var merchant_card = raycast_check_for_merchant_card()
			if merchant_card:
				start_drag_card(merchant_card)
		else:
			if card_being_dragged:
				finish_drag_card()

func start_drag_card(card):
	card_being_dragged = card
	card.get_node("CardUI").mouse_filter = Control.MOUSE_FILTER_IGNORE
	card_being_dragged.scale = Vector2(1.1, 1.1)
	card_being_dragged.z_index = 2
	card_previous_position = card.position

func finish_drag_card():
	var deck_card_slot_found = raycast_check_for_deck_slot()
	var inventory_card_slot_found = raycast_check_for_inventory_slot()
	
	deck_card_slot_index = deck_card_slot_array.find(deck_card_slot_found)
	inventory_card_slot_index = inventory_card_slot_array.find(inventory_card_slot_found)

	if raycast_check_for_deck_slot() and not deck_card_slot_found.card_in_slot and not card_being_dragged.card_stats.is_players:
		buy_card_for_deck(card_being_dragged, deck_card_slot_found)
		print("Buy card for Deck")
		card_reset()
		return
	
	if raycast_check_for_inventory_slot() and not inventory_card_slot_found.card_in_slot and not card_being_dragged.card_stats.is_players:
		buy_card_for_inventory(card_being_dragged, inventory_card_slot_found)
		print("Buy card for Inventory")
		card_reset()
		return
	
	if raycast_check_for_card() and not card_being_dragged.card_stats.is_players:
		var temp = upgrade_from_merchant(card_being_dragged, raycast_check_for_upgrade_card())
		print("Upgrade from merchant")
		hover_on_upgrade_test = false
		card_reset()
		hover_on_upgrade_test = true
		return
	
	if !card_being_dragged.card_stats.is_players:
		$"../CardSelectionCreator".add_card_to_hand(card_being_dragged)
	
	card_reset()

func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return get_card_with_highest_z_index(result)
	return null 

func raycast_check_for_upgrade_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return get_card_with_lowest_z_index(result)
	return null 

func raycast_check_for_merchant_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_MERCHANT_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return get_card_with_highest_z_index(result)
	return null 

func raycast_check_for_deck_slot():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_DECK_SLOT
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null 

func raycast_check_for_inventory_slot():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_INVENTORY_SLOT
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null 

func get_card_with_highest_z_index(cards):
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	
	for i in range(1, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card

func get_card_with_lowest_z_index(cards):
	var lowest_z_card = cards[0].collider.get_parent()
	var lowest_z_index = lowest_z_card.z_index
	
	for i in range(1, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index < lowest_z_index:
			lowest_z_card = current_card
			lowest_z_index = current_card.z_index
	return lowest_z_card

func buy_card_for_deck(card, deck_slot):
	if Global.player_gold < card.card_stats.buy_price:
		merchant_inventory_reference.add_card_to_hand(card)
		print("Not enough gold")
		return
	Global.player_gold -= card.card_stats.buy_price
	merchant_inventory_reference.remove_card_from_hand(card)
	card.get_node("Area2D").collision_layer = COLLISION_MASK_CARD
	card.get_node("Area2D").collision_mask = COLLISION_MASK_CARD
	card_being_dragged.position = deck_slot.position
	deck_slot.card_in_slot = true
	deck_card_slot_reference.remove_at(deck_card_slot_index)
	deck_card_slot_reference.insert(deck_card_slot_index, card_being_dragged)
	card.card_stats.is_players = true
	card.card_shop_ui()
	update_player_gold()

func buy_card_for_inventory(card, inventory_slot):
	if Global.player_gold < card.card_stats.buy_price:
		merchant_inventory_reference.add_card_to_hand(card)
		print("Not enough gold")
		return
	Global.player_gold -= card.card_stats.buy_price
	merchant_inventory_reference.remove_card_from_hand(card)
	card.get_node("Area2D").collision_layer = COLLISION_MASK_CARD
	card.get_node("Area2D").collision_mask = COLLISION_MASK_CARD
	card_being_dragged.position = inventory_slot.position
	inventory_slot.card_in_slot = true
	inventory_card_slot_reference.remove_at(inventory_card_slot_index)
	inventory_card_slot_reference.insert(inventory_card_slot_index, card_being_dragged)
	card.card_stats.is_players = true
	card.card_shop_ui()
	update_player_gold()

func upgrade_check(upgrade_card, base_card):
	if upgrade_card.z_index == base_card.z_index: 
		print("Can't upgrade different positions")
		return false
	if upgrade_card.card_stats.upgrade_level != base_card.card_stats.upgrade_level: 
		print("Can't upgrade different levels")
		return false
	if base_card.card_stats.upgrade_level >= 4: 
		print("Can't upgrade, max level")
		return false
	if base_card.card_stats.card_scene_path != upgrade_card.card_stats.card_scene_path:
		return false
	return true

func upgrade_from_merchant(upgrade_card, base_card):
	if  upgrade_card.position != base_card.position and upgrade_card.card_stats.upgrade_level == base_card.card_stats.upgrade_level:
		if Global.player_gold < upgrade_card.card_stats.buy_price:
			merchant_inventory_reference.add_card_to_hand(upgrade_card)
			print("Not enough gold")
			return
		if base_card.card_stats.card_scene_path != upgrade_card.card_stats.card_scene_path:
			merchant_inventory_reference.add_card_to_hand(upgrade_card)
			return
		if base_card.card_stats.upgrade_level >= 4:
			merchant_inventory_reference.add_card_to_hand(upgrade_card)
			return
		Global.player_gold -= base_card.card_stats.buy_price
		var temp_enchant = base_card.card_stats.item_enchant
		var temp_enchant2 = upgrade_card.card_stats.item_enchant
		if temp_enchant != null:
			base_card.item_enchant(temp_enchant) 
		if temp_enchant2 != null:
			base_card.item_enchant(temp_enchant2) 
		merchant_inventory_reference.remove_card_from_hand(upgrade_card)
		upgrade_card.queue_free()
		base_card.upgrade_card(base_card.card_stats.upgrade_level + 1)
		base_card.update_card_ui()
		base_card.card_shop_ui()
		update_player_gold()
		return base_card
	else:
		merchant_inventory_reference.add_card_to_hand(upgrade_card)
		return base_card
	pass

func update_player_gold():
	$"../BottomNavBar/ColorRect/PlayerUI".change_player_gold() 

func card_reset():
	card_being_dragged.get_node("CardUI").mouse_filter = Control.MOUSE_FILTER_STOP
	card_being_dragged.scale = Vector2(1, 1)
	card_being_dragged.z_index = 1
	card_being_dragged = null

