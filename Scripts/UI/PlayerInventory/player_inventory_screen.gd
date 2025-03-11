extends Node2D

var playerData = PlayerData.new()

const CARD_WIDTH = 130
const HAND_Y_POSITION = 630
const COLLISION_MASK_CARD = 1
const COLLISION_MASK_DECK_SLOT = 2
const COLLISION_MASK_INVENTORY_SLOT = 4
const COLLISION_MASK_SELL_ZONE = 128

var upgrade_mode = false
var deck_reference
var inventory_reference
var card_being_dragged
var center_screen_x
var screen_size
var card_previous_position
var deck_card_slot_array = []
var deck_card_slot_reference = []
var inventory_card_slot_array = []
var inventory_card_slot_reference = []


func _ready():
	center_screen_x = get_viewport().size.x / 2
	screen_size = get_viewport_rect().size
	inventory_collision_toggle()
	deck_reference = $ActiveDeck
	inventory_reference = $CurrentInventory
	
	for i in $DeckCardSlots.get_children():
		deck_card_slot_array.push_front(i)
	
	for i in $InventorySlots.get_children():
		inventory_card_slot_array.push_front(i)
	
	deck_card_slot_reference = $ActiveDeck.card_slot_reference
	inventory_card_slot_reference = $CurrentInventory.card_slot_reference

func _process(delta):
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), 
			clamp(mouse_pos.y, 0, screen_size.y))

#INPUT AND DRAG FUNCTIONS---------------------------------------------------------------------------
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var card = raycast_check_for_card()
			if card:
				start_drag(card)
		else:
			if card_being_dragged:
				finish_drag()

func start_drag(card):
	card_being_dragged = card
	card_being_dragged.scale = Vector2(1.1, 1.1)
	card_being_dragged.z_index = 2
	card_previous_position = card.position

func finish_drag():
	var deck_card_slot_found = raycast_check_for_deck_slot()
	var inventory_card_slot_found = raycast_check_for_inventory_slot()
	
	var sell_zone_found = raycast_check_for_sell_zone()
	
	
	var deck_card_slot_index = deck_card_slot_array.find(deck_card_slot_found)
	var deck_card_slot_reference_index = deck_card_slot_reference.find(card_being_dragged)
	
	var inventory_card_slot_index = inventory_card_slot_array.find(inventory_card_slot_found)
	var inventory_card_slot_reference_index =  inventory_card_slot_reference.find(card_being_dragged)
	
	var card_being_replaced
	var previous_card_slot
	
	if sell_zone_found:
		var temp_inventory_reference = inventory_card_slot_reference.find(card_being_dragged)
		var temp_inventory_card = inventory_card_slot_reference[inventory_card_slot_index]
		if temp_inventory_reference > 0:
			inventory_card_slot_reference[temp_inventory_reference] = null
			inventory_card_slot_array[temp_inventory_reference].card_in_slot = false
		var temp_deck_reference = deck_card_slot_reference.find(card_being_dragged)
		var temp_deck_card = deck_card_slot_reference[deck_card_slot_index]
		if temp_deck_reference > 0:
			deck_card_slot_reference[temp_deck_reference] = null
			deck_card_slot_array[temp_deck_reference].card_in_slot = false
		sell_card(card_being_dragged)

	
	if upgrade_mode:
		if raycast_check_for_card() and raycast_check_for_upgrade_card():
			if upgrade_check(card_being_dragged, raycast_check_for_upgrade_card()):
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
				upgrade_card(card_being_dragged, raycast_check_for_upgrade_card())
				print("Upgrade card")
				card_being_dragged = null
				return
	
	#If the card being dragged is from a card slot and is landing on an occupied card slot
	if deck_card_slot_reference_index  > -1 and deck_card_slot_found != null:
		previous_card_slot = deck_card_slot_reference_index
		if deck_card_slot_found.card_in_slot:
			card_being_replaced = deck_card_slot_reference[deck_card_slot_index]
			
		deck_card_slot_reference[deck_card_slot_reference_index] = null
		deck_card_slot_array[deck_card_slot_reference_index].card_in_slot = false
	
	if deck_card_slot_found and not deck_card_slot_found.card_in_slot:
		card_being_dragged.position = deck_card_slot_found.position
		deck_card_slot_found.card_in_slot = true
		deck_card_slot_reference.remove_at(deck_card_slot_index)
		deck_card_slot_reference.insert(deck_card_slot_index, card_being_dragged)
		var temp_reference = inventory_card_slot_reference.find(card_being_dragged)
		if temp_reference >= 0:
			inventory_card_slot_reference[temp_reference] = null
			inventory_card_slot_array[temp_reference].card_in_slot = false
		print("I am Here 1")

	elif deck_card_slot_found and deck_card_slot_found.card_in_slot and !upgrade_mode:
		card_being_dragged.position = deck_card_slot_found.position
		deck_card_slot_found.card_in_slot = true 
		
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
						
						
		else:
			var temp_reference = inventory_card_slot_reference.find(card_being_dragged)
			var temp_card = deck_card_slot_reference[deck_card_slot_index]
			deck_reference.animate_card_to_position(card_being_dragged, deck_card_slot_array[deck_card_slot_index].position)
			deck_card_slot_reference.remove_at(deck_card_slot_index)
			deck_card_slot_reference.insert(deck_card_slot_index, card_being_dragged)
			inventory_reference.animate_card_to_position(temp_card, inventory_card_slot_array[temp_reference].position)
			inventory_card_slot_reference.remove_at(temp_reference)
			inventory_card_slot_reference.insert(temp_reference, temp_card)
			print("I am Here 6")

			
#==================================================================================================
	#If the card being dragged is from a card slot and is landing on an occupied card slot
	if inventory_card_slot_reference_index  > -1 and inventory_card_slot_found != null:
		previous_card_slot = inventory_card_slot_reference_index
		if inventory_card_slot_found.card_in_slot:
			card_being_replaced =  inventory_card_slot_reference[inventory_card_slot_index]
			
		inventory_card_slot_reference[inventory_card_slot_reference_index] = null
		inventory_card_slot_array[inventory_card_slot_reference_index].card_in_slot = false
	
	if inventory_card_slot_found and not inventory_card_slot_found.card_in_slot:
		card_being_dragged.position = inventory_card_slot_found.position
		inventory_card_slot_found.card_in_slot = true
		inventory_card_slot_reference.remove_at(inventory_card_slot_index)
		inventory_card_slot_reference.insert(inventory_card_slot_index, card_being_dragged)
		var temp_reference = deck_card_slot_reference.find(card_being_dragged)
		if temp_reference >= 0:
			deck_card_slot_reference[temp_reference] = null
			deck_card_slot_array[temp_reference].card_in_slot = false
		print("I am Here 7")
		
	elif inventory_card_slot_found and inventory_card_slot_found.card_in_slot and !upgrade_mode:
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
		else:
			var temp_reference = deck_card_slot_reference.find(card_being_dragged)
			var temp_card = inventory_card_slot_reference[inventory_card_slot_index]
			inventory_reference.animate_card_to_position(card_being_dragged, inventory_card_slot_array[inventory_card_slot_index].position)
			inventory_card_slot_reference.remove_at(inventory_card_slot_index)
			inventory_card_slot_reference.insert(inventory_card_slot_index, card_being_dragged)
			deck_reference.animate_card_to_position(temp_card, deck_card_slot_array[temp_reference].position)
			deck_card_slot_reference.remove_at(temp_reference)
			deck_card_slot_reference.insert(temp_reference, temp_card)
			print("I am Here 12")


#==================================================================================================
	if !deck_card_slot_found and !inventory_card_slot_found:
		print("I am here 13")
		card_being_dragged.scale = Vector2(1, 1)
		card_being_dragged.z_index = 1
		deck_reference.animate_card_to_position(card_being_dragged, card_previous_position)
		card_being_dragged = null
	
	if upgrade_mode and card_being_dragged:
		deck_reference.animate_card_to_position(card_being_dragged, card_previous_position)
		card_being_dragged.scale = Vector2(1, 1)
		card_being_dragged.z_index = 1
		card_being_dragged = null
	
	if card_being_dragged != null:
		card_being_dragged.scale = Vector2(1, 1)
		card_being_dragged.z_index = 1
		card_being_dragged = null

func upgrade_card(upgrade_card, base_card):
		upgrade_card.queue_free()
		base_card.upgrade_card(base_card.card_stats.upgrade_level + 1)
		base_card.update_card_ui()
		print("Upgrade card end")

	
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

func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
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

func raycast_check_for_sell_zone():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_SELL_ZONE
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null 


func sell_card(card):
	Global.player_gold += card.card_stats.sell_price
	deck_reference.remove_card(card)
	card.queue_free()
	card
	update_player_gold()


func inventory_collision_toggle():
	for i in get_children():
			if !i.is_in_group("card"): continue
			if i.disabled_collision:
				i.enable_collision()
			else:
				i.disable_collision()

func get_card_with_lowest_z_index(cards):
	var lowest_z_card = cards[0].collider.get_parent()
	var lowest_z_index = lowest_z_card.z_index
	
	for i in range(1, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index < lowest_z_index:
			lowest_z_card = current_card
			lowest_z_index = current_card.z_index
	return lowest_z_card

func update_player_gold():
	pass
	$"../PlayerUI".change_player_gold() 


func _on_upgrade_button_toggled(toggled_on):
	upgrade_mode = toggled_on

func upgrade_check(upgrade_card, base_card):
	if upgrade_card.position == base_card.position: return false
	if upgrade_card.card_stats.upgrade_level != base_card.card_stats.upgrade_level: return false
	if base_card.card_stats.upgrade_level >= 4: return false
	return true
