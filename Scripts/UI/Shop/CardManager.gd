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
var inventory_reference_index
var deck_reference_index
var previous_card_slot

func _ready():
	screen_size = get_viewport_rect().size
	merchant_inventory_reference = $"../MerchantCards"
	inventory_reference = $"../PlayerInventory"
	deck_reference = $"../PlayerDeck"
	
	for i in get_children():
		if !i.card_stats.is_players:
			print("Merchant Inventory")
	
	for i in $"../DeckCardSlots".get_children():
		deck_card_slot_array.push_front(i)
	
	for i in $"../InventorySlots".get_children():
		inventory_card_slot_array.push_front(i)
	
	deck_card_slot_reference = $"../PlayerDeck".card_slot_reference
	inventory_card_slot_reference = $"../PlayerInventory".card_slot_reference

func _process(delta):
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), 
			clamp(mouse_pos.y, 0, screen_size.y))

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var merchant_card = raycast_check_for_merchant_card()
			var player_card = raycast_check_for_card()
			if merchant_card:
				start_drag(merchant_card)
			if player_card:
				start_drag(player_card)
		else:
			if card_being_dragged:
				finish_drag()

func start_drag(card):
	card_being_dragged = card
	card_being_dragged.scale = Vector2(1.1, 1.1)
	card_being_dragged.z_index = 2

func finish_drag():
	var deck_card_slot_found = raycast_check_for_deck_slot()
	var inventory_card_slot_found = raycast_check_for_inventory_slot()
	
	deck_card_slot_index = deck_card_slot_array.find(deck_card_slot_found)
	deck_card_slot_reference_index = deck_card_slot_reference.find(card_being_dragged)
	
	
	inventory_card_slot_index = inventory_card_slot_array.find(inventory_card_slot_found)
	inventory_card_slot_reference_index =  inventory_card_slot_reference.find(card_being_dragged)
	
	inventory_reference_index = inventory_card_slot_reference.find(card_being_dragged)
	deck_reference_index = deck_card_slot_reference.find(card_being_dragged)
	
	if deck_card_slot_reference_index  > -1 and deck_card_slot_found != null:
		previous_card_slot = deck_card_slot_reference_index
		deck_card_slot_reference[deck_card_slot_reference_index] = null
		deck_card_slot_array[deck_card_slot_reference_index].card_in_slot = false
	
	if deck_card_slot_found and not deck_card_slot_found.card_in_slot and card_being_dragged.card_stats.is_players:
		move_from_inventory_to_deck(card_being_dragged, deck_card_slot_found)
	elif deck_card_slot_found and deck_card_slot_found.card_in_slot and !upgrade_mode and card_being_dragged.card_stats.is_players:
		if deck_card_slot_reference_index > -1:
			deck_sorting(card_being_dragged, deck_card_slot_found)
		else: inventory_to_deck_swap()

	if inventory_card_slot_reference_index  > -1 and inventory_card_slot_found != null:
		previous_card_slot = inventory_card_slot_reference_index
		inventory_card_slot_reference[inventory_card_slot_reference_index] = null
		inventory_card_slot_array[inventory_card_slot_reference_index].card_in_slot = false
	
	if inventory_card_slot_found and not inventory_card_slot_found.card_in_slot and card_being_dragged.card_stats.is_players:
		move_from_deck_to_inventory(card_being_dragged, inventory_card_slot_found)
	elif inventory_card_slot_found and inventory_card_slot_found.card_in_slot and !upgrade_mode and card_being_dragged.card_stats.is_players:
		if inventory_card_slot_reference_index > -1:
			inventory_sorting(card_being_dragged, inventory_card_slot_found)
		else: deck_to_inventory_swap()
	
	if raycast_check_for_card() and card_being_dragged.card_stats.is_enchantment:
		enchant_from_merchant(card_being_dragged, raycast_check_for_card())
		print("Enchant card")
		card_being_dragged = null
		return
	
	if raycast_check_for_deck_slot() and not deck_card_slot_found.card_in_slot and not card_being_dragged.card_stats.is_players:
		buy_card_for_deck(card_being_dragged, deck_card_slot_found)
		print("Buy card for Deck")
		card_being_dragged = null
		return
	
	if raycast_check_for_inventory_slot() and not inventory_card_slot_found.card_in_slot and not card_being_dragged.card_stats.is_players:
		buy_card_for_inventory(card_being_dragged, inventory_card_slot_found)
		print("Buy card for Inventory")
		card_being_dragged = null
		return
	
	if raycast_check_for_merchant() and card_being_dragged.card_stats.is_players:
		sell_card(card_being_dragged)
		card_being_dragged = null
		return
	
	if raycast_check_for_card() and card_being_dragged.card_stats.is_players:
		if upgrade_check(card_being_dragged, raycast_check_for_upgrade_card()):
			upgrade_card(card_being_dragged, raycast_check_for_upgrade_card())
			print("Upgrade card")
			card_being_dragged = null
			return
	
	if raycast_check_for_card() and not card_being_dragged.card_stats.is_players and upgrade_mode:
		upgrade_from_merchant(card_being_dragged, raycast_check_for_upgrade_card())
		print("Upgrade from merchant")
		card_being_dragged = null
		return
	
		
	if !card_being_dragged.card_stats.is_players:
		$"../MerchantCards".add_card_to_hand(card_being_dragged)
		

	
	card_being_dragged = null

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

func raycast_check_for_merchant():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_MERCHANT
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0]
	return null 

func raycast_check_for_player():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_PLAYER
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0]
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

func sell_card(card):
	print(deck_card_slot_reference_index)
	Global.player_gold += card.card_stats.sell_price
	merchant_inventory_reference.add_card_to_hand(card)
	
	if inventory_card_slot_reference_index >= 0:
		inventory_card_slot_reference[inventory_card_slot_reference_index] = null
		inventory_card_slot_array[inventory_card_slot_reference_index].card_in_slot = false
	if deck_card_slot_reference_index >= 0:
		deck_card_slot_reference[deck_card_slot_reference_index] = null
		deck_card_slot_array[deck_card_slot_reference_index].card_in_slot = false
		
	card.get_node("Area2D").collision_layer = COLLISION_MASK_MERCHANT_CARD
	card.get_node("Area2D").collision_mask = COLLISION_MASK_MERCHANT_CARD
	card.card_stats.is_players = false
	card.card_shop_ui()
	update_player_gold()
	
	for i in deck_card_slot_array:
		print(i.card_in_slot)
	
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

func upgrade_card(upgrade_card, base_card):
	var temp_inventory_reference = inventory_card_slot_reference.find(card_being_dragged)
	var temp_inventory_card = inventory_card_slot_reference[inventory_card_slot_index]
	if temp_inventory_reference >= 0:
		inventory_card_slot_reference[temp_inventory_reference] = null
		inventory_card_slot_array[temp_inventory_reference].card_in_slot = false
	var temp_deck_reference = deck_card_slot_reference.find(card_being_dragged)
	var temp_deck_card = deck_card_slot_reference[deck_card_slot_index]
	if temp_deck_reference >= 0:
		deck_card_slot_reference[temp_deck_reference] = null
		deck_card_slot_array[temp_deck_reference].card_in_slot = false
	upgrade_card.queue_free()
	base_card.upgrade_card(base_card.card_stats.upgrade_level + 1)
	print("Upgrade card end")

func upgrade_check(upgrade_card, base_card):
	if upgrade_card.position == base_card.position: return false
	if upgrade_card.card_stats.upgrade_level != base_card.card_stats.upgrade_level: return false
	if base_card.card_stats.upgrade_level >= 4: return false
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
		merchant_inventory_reference.remove_card_from_hand(upgrade_card)
		upgrade_card.queue_free()
		base_card.upgrade_card(base_card.card_stats.upgrade_level + 1)
		base_card.update_card_ui()
		base_card.card_shop_ui()
		update_player_gold()
	else:
		merchant_inventory_reference.add_card_to_hand(upgrade_card)
	pass

func enchant_from_merchant(enchant_card, base_card):
	if Global.player_gold < enchant_card.card_stats.buy_price:
			merchant_inventory_reference.add_card_to_hand(enchant_card)
			print("Not enough gold")
			return
	Global.player_gold -= enchant_card.card_stats.buy_price
	merchant_inventory_reference.remove_card_from_hand(enchant_card)
	enchant_card.queue_free()
	base_card.item_enchant(enchant_card.card_stats.enchanting_with)
	base_card.update_card_ui()
	base_card.card_shop_ui()
	update_player_gold()

func move_from_inventory_to_deck(card_being_dragged, deck_slot):
	card_being_dragged.position = deck_slot.position
	deck_slot.card_in_slot = true
	deck_card_slot_reference.remove_at(deck_card_slot_index)
	deck_card_slot_reference.insert(deck_card_slot_index, card_being_dragged)
	if inventory_card_slot_reference_index >= 0:
		inventory_card_slot_reference[inventory_card_slot_reference_index] = null
		inventory_card_slot_array[inventory_card_slot_reference_index].card_in_slot = false
	print("I am Here 1")
	
	for i in deck_card_slot_array:
		print(i.card_in_slot)
	
	print("Breaks")
	for i in inventory_card_slot_array:
		print(i.card_in_slot)

func move_from_deck_to_inventory(card_being_dragged, inventory_slot):
	card_being_dragged.position = inventory_slot.position
	inventory_slot.card_in_slot = true
	inventory_card_slot_reference.remove_at(inventory_card_slot_index)
	inventory_card_slot_reference.insert(inventory_card_slot_index, card_being_dragged)
	if deck_card_slot_reference_index >= 0:
		deck_card_slot_reference[deck_card_slot_reference_index] = null
		deck_card_slot_array[deck_card_slot_reference_index].card_in_slot = false
	print("I am Here 1")

	for i in deck_card_slot_array:
		print(i.card_in_slot)
	
	print("Breaks")
	for i in inventory_card_slot_array:
		print(i.card_in_slot)
		
func deck_sorting(card_being_dragged, deck_slot):
	card_being_dragged.position = deck_slot.position
	deck_slot.card_in_slot = true 
	
	if deck_card_slot_reference_index > -1:
		#true card_being_dragged going to the right
		var direction_shift = true
		if deck_card_slot_index < previous_card_slot:
			direction_shift = false
			
		var loop_counter = 0
		var temp_card = card_being_dragged
		if direction_shift:
			while loop_counter != 20:
				deck_reference.animate_card_to_position(temp_card, deck_card_slot_array[deck_card_slot_index-loop_counter].position)
				#Checks to see if its taking over an occupied spot
				if deck_card_slot_reference[deck_card_slot_index-loop_counter] == null:
					deck_card_slot_reference.remove_at(deck_card_slot_index-loop_counter)
					deck_card_slot_reference.insert(deck_card_slot_index-loop_counter, temp_card)
					deck_card_slot_array[deck_card_slot_index-loop_counter].card_in_slot = true
					print("I am Here 2")
					break
				else: 
					var second_temp = deck_card_slot_reference[deck_card_slot_index-loop_counter]
					deck_card_slot_reference.remove_at(deck_card_slot_index-loop_counter)
					deck_card_slot_reference.insert(deck_card_slot_index-loop_counter, temp_card)
					deck_card_slot_array[deck_card_slot_index-loop_counter].card_in_slot = true
					temp_card = second_temp
					loop_counter += 1
					print("I am Here 3")

		else:
			while loop_counter != 20:
				deck_reference.animate_card_to_position(temp_card, deck_card_slot_array[deck_card_slot_index+loop_counter].position)
				#Checks to see if its taking over an occupied spot
				if deck_card_slot_reference[deck_card_slot_index+loop_counter] == null:
					deck_card_slot_reference.remove_at(deck_card_slot_index+loop_counter)
					deck_card_slot_reference.insert(deck_card_slot_index+loop_counter, temp_card)
					deck_card_slot_array[deck_card_slot_index+loop_counter].card_in_slot = true
					print("I am Here 4")
					break
				else: 
					var second_temp = deck_card_slot_reference[deck_card_slot_index+loop_counter]
					deck_card_slot_reference.remove_at(deck_card_slot_index+loop_counter)
					deck_card_slot_reference.insert(deck_card_slot_index+loop_counter, temp_card)
					deck_card_slot_array[deck_card_slot_index+loop_counter].card_in_slot = true
					temp_card = second_temp
					loop_counter += 1
					print("I am Here 5")

func inventory_to_deck_swap():
	var temp_reference = inventory_card_slot_reference.find(card_being_dragged)
	var temp_card = deck_card_slot_reference[deck_card_slot_index]
	deck_reference.animate_card_to_position(card_being_dragged, deck_card_slot_array[deck_card_slot_index].position)
	deck_card_slot_reference.remove_at(deck_card_slot_index)
	deck_card_slot_reference.insert(deck_card_slot_index, card_being_dragged)
	inventory_reference.animate_card_to_position(temp_card, inventory_card_slot_array[temp_reference].position)
	inventory_card_slot_reference.remove_at(temp_reference)
	inventory_card_slot_reference.insert(temp_reference, temp_card)
	print("I am Here 6")

func inventory_sorting(card_being_dragged, inventory_card_slot_found):
	card_being_dragged.position = inventory_card_slot_found.position
	inventory_card_slot_found.card_in_slot = true 
	
	if inventory_card_slot_reference_index > -1:
		#true card_being_dragged to the right
		var direction_shift = true
		if inventory_card_slot_index < previous_card_slot:
			direction_shift = false
			
		var loop_counter = 0
		var temp_card = card_being_dragged
		if direction_shift:
			while loop_counter != 20:
				inventory_reference.animate_card_to_position(temp_card, inventory_card_slot_array[inventory_card_slot_index-loop_counter].position)
				#Checks to see if its taking over an occupied spot
				if inventory_card_slot_reference[inventory_card_slot_index-loop_counter] == null:
					inventory_card_slot_reference.remove_at(inventory_card_slot_index-loop_counter)
					inventory_card_slot_reference.insert(inventory_card_slot_index-loop_counter, temp_card)
					inventory_card_slot_array[inventory_card_slot_index-loop_counter].card_in_slot = true
					print("I am Here 8")
					break
				else: 
					var second_temp = inventory_card_slot_reference[inventory_card_slot_index-loop_counter]
					inventory_card_slot_reference.remove_at(inventory_card_slot_index-loop_counter)
					inventory_card_slot_reference.insert(inventory_card_slot_index-loop_counter, temp_card)
					inventory_card_slot_array[inventory_card_slot_index-loop_counter].card_in_slot = true
					temp_card = second_temp
					loop_counter += 1
					print("I am Here 9")

		else:
			while loop_counter != 20:
				inventory_reference.animate_card_to_position(temp_card, inventory_card_slot_array[inventory_card_slot_index+loop_counter].position)
				#Checks to see if its taking over an occupied spot
				if inventory_card_slot_reference[inventory_card_slot_index+loop_counter] == null:
					inventory_card_slot_reference.remove_at(inventory_card_slot_index+loop_counter)
					inventory_card_slot_reference.insert(inventory_card_slot_index+loop_counter, temp_card)
					inventory_card_slot_array[inventory_card_slot_index+loop_counter].card_in_slot = true
					print("I am Here 10")
					break
				else: 
					var second_temp = inventory_card_slot_reference[inventory_card_slot_index+loop_counter]
					inventory_card_slot_reference.remove_at(inventory_card_slot_index+loop_counter)
					inventory_card_slot_reference.insert(inventory_card_slot_index+loop_counter, temp_card)
					inventory_card_slot_array[inventory_card_slot_index+loop_counter].card_in_slot = true
					temp_card = second_temp
					loop_counter += 1
					print("I am Here 11")

func deck_to_inventory_swap():
	var temp_reference = deck_card_slot_reference.find(card_being_dragged)
	var temp_card = inventory_card_slot_reference[inventory_card_slot_index]
	inventory_reference.animate_card_to_position(card_being_dragged, inventory_card_slot_array[inventory_card_slot_index].position)
	inventory_card_slot_reference.remove_at(inventory_card_slot_index)
	inventory_card_slot_reference.insert(inventory_card_slot_index, card_being_dragged)
	deck_reference.animate_card_to_position(temp_card, deck_card_slot_array[temp_reference].position)
	deck_card_slot_reference.remove_at(temp_reference)
	deck_card_slot_reference.insert(temp_reference, temp_card)
	print("I am Here 12")
func update_player_gold():
	pass
	$"../PlayerUI".change_player_gold() 


func _on_upgrade_button_toggled(toggled_on):
	upgrade_mode = toggled_on
