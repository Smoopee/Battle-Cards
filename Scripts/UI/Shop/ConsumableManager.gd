extends Node2D

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_DECK_SLOT = 2
const COLLISION_MASK_INVENTORY_SLOT = 4
const COLLISION_MASK_MERCHANT = 32

var screen_size
var deck_reference
var inventory_reference
var deck_card_slot_array = []
var deck_card_slot_reference = []
var inventory_card_slot_array = []
var inventory_card_slot_reference = []

var hover_on_upgrade_test = true
var upgrade_mode = false
var card_previous_position
var deck_card_slot_index 
var deck_card_slot_reference_index
var inventory_card_slot_index
var inventory_card_slot_reference_index
var previous_card_slot

var card_being_dragged

func _ready():
	screen_size = get_viewport_rect().size
	inventory_reference = $"../PlayerInventory"
	deck_reference = $"../PlayerDeck"
	
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
	if $"..".merchant_type != "Skill": return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var player_card = raycast_check_for_card()
			if player_card:
				start_drag(player_card)
		else:
			if card_being_dragged:
				finish_drag()

func start_drag(card):
	card_being_dragged = card
	card.get_node("CardUI").mouse_filter = Control.MOUSE_FILTER_IGNORE
	card_being_dragged.scale = Vector2(1.1, 1.1)
	card_being_dragged.z_index = 2
	card_previous_position = card.position

func finish_drag():
	var deck_card_slot_found = raycast_check_for_deck_slot()
	var inventory_card_slot_found = raycast_check_for_inventory_slot()
	var card_sorted = false
	
	deck_card_slot_index = deck_card_slot_array.find(deck_card_slot_found)
	deck_card_slot_reference_index = deck_card_slot_reference.find(card_being_dragged)
	
	inventory_card_slot_index = inventory_card_slot_array.find(inventory_card_slot_found)
	inventory_card_slot_reference_index =  inventory_card_slot_reference.find(card_being_dragged)
	
	var can_sort_deck =  deck_card_slot_found and deck_card_slot_found.card_in_slot and card_being_dragged.card_stats.is_players
	var can_sort_inventory =  inventory_card_slot_found and inventory_card_slot_found.card_in_slot and card_being_dragged.card_stats.is_players
	
	if deck_card_slot_reference_index  > -1 and deck_card_slot_found != null:
		previous_card_slot = deck_card_slot_reference_index
		deck_card_slot_reference[deck_card_slot_reference_index] = null
		deck_card_slot_array[deck_card_slot_reference_index].card_in_slot = false
	
	if deck_card_slot_found and not deck_card_slot_found.card_in_slot and card_being_dragged.card_stats.is_players:
		move_from_inventory_to_deck(card_being_dragged, deck_card_slot_found)
		card_sorted = true
	elif can_sort_deck:
		if !upgrade_mode or (upgrade_mode and !upgrade_check(card_being_dragged, raycast_check_for_upgrade_card())):
			if deck_card_slot_reference_index > -1:
				deck_sorting(card_being_dragged, deck_card_slot_found)
			else: inventory_to_deck_swap(card_being_dragged, deck_card_slot_found)
		card_sorted = true

	if inventory_card_slot_reference_index  > -1 and inventory_card_slot_found != null:
		previous_card_slot = inventory_card_slot_reference_index
		inventory_card_slot_reference[inventory_card_slot_reference_index] = null
		inventory_card_slot_array[inventory_card_slot_reference_index].card_in_slot = false
	
	if inventory_card_slot_found and not inventory_card_slot_found.card_in_slot and card_being_dragged.card_stats.is_players:
		move_from_deck_to_inventory(card_being_dragged, inventory_card_slot_found)
		card_sorted = true
	elif can_sort_inventory:
		if !upgrade_mode or (upgrade_mode and !upgrade_check(card_being_dragged, raycast_check_for_upgrade_card())):
			if inventory_card_slot_reference_index > -1:
				inventory_sorting(card_being_dragged, inventory_card_slot_found)
			else: deck_to_inventory_swap(card_being_dragged, inventory_card_slot_found)
		card_sorted = true
	
	if raycast_check_for_merchant() and card_being_dragged.card_stats.is_players:
		sell_card(card_being_dragged)
		print("Sell Card")
		card_reset()
		return
	
	if raycast_check_for_card() and card_being_dragged.card_stats.is_players and upgrade_mode:
		if upgrade_check(card_being_dragged, raycast_check_for_upgrade_card()):
			var temp = upgrade_card(card_being_dragged, raycast_check_for_upgrade_card())
			print("Upgrade card")
			hover_on_upgrade_test = false
			on_hovered_over(temp)
			card_reset()
			hover_on_upgrade_test = true
			return
	
	if !card_sorted: inventory_reference.animate_card_to_position(card_being_dragged, card_previous_position)
	card_sorted = false
	card_reset()
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

func upgrade_card(upgrade_card, base_card):
	var temp_inventory_card = inventory_card_slot_reference[inventory_card_slot_index]
	if inventory_card_slot_reference_index >= 0:
		inventory_card_slot_reference[inventory_card_slot_reference_index] = null
		inventory_card_slot_array[inventory_card_slot_reference_index].card_in_slot = false
	var temp_deck_card = deck_card_slot_reference[deck_card_slot_index]
	if deck_card_slot_reference_index >= 0:
		deck_card_slot_reference[deck_card_slot_reference_index] = null
		deck_card_slot_array[deck_card_slot_reference_index].card_in_slot = false
	var temp_enchant = base_card.card_stats.item_enchant
	var temp_enchant2 = upgrade_card.card_stats.item_enchant
	if temp_enchant != null:
		base_card.item_enchant(temp_enchant) 
	if temp_enchant2 != null:
		base_card.item_enchant(temp_enchant2) 
	upgrade_card.queue_free()
	base_card.upgrade_card(base_card.card_stats.upgrade_level + 1)
	return base_card
	print("Upgrade card end")

func move_from_inventory_to_deck(card_being_dragged, deck_slot):
	card_being_dragged.position = deck_slot.position
	deck_slot.card_in_slot = true
	deck_card_slot_reference.remove_at(deck_card_slot_index)
	deck_card_slot_reference.insert(deck_card_slot_index, card_being_dragged)
	if inventory_card_slot_reference_index >= 0:
		inventory_card_slot_reference[inventory_card_slot_reference_index] = null
		inventory_card_slot_array[inventory_card_slot_reference_index].card_in_slot = false
	print("I am Here 1")
	
func move_from_deck_to_inventory(card_being_dragged, inventory_slot):
	card_being_dragged.position = inventory_slot.position
	inventory_slot.card_in_slot = true
	inventory_card_slot_reference.remove_at(inventory_card_slot_index)
	inventory_card_slot_reference.insert(inventory_card_slot_index, card_being_dragged)
	if deck_card_slot_reference_index >= 0:
		deck_card_slot_reference[deck_card_slot_reference_index] = null
		deck_card_slot_array[deck_card_slot_reference_index].card_in_slot = false
	print("I am Here 7")

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

func inventory_to_deck_swap(card_being_dragged, deck_slot):
	var deck_full = true
	for i in deck_card_slot_array:
		if i.card_in_slot == false:
			deck_full = false
	
	var null_index = deck_card_slot_reference.find(null)

	if !deck_full:
		card_being_dragged.position = deck_slot.position
		deck_slot.card_in_slot = true 
		
			#true card_being_dragged going to the right
		var direction_shift = true
		print("Null index is  " + str(null_index))
		if deck_card_slot_index < null_index:
			direction_shift = false
			
		var loop_counter = 0
		var temp_card = card_being_dragged
		if inventory_card_slot_reference_index >= 0:
			inventory_card_slot_reference[inventory_card_slot_reference_index] = null
			inventory_card_slot_array[inventory_card_slot_reference_index].card_in_slot = false
		if direction_shift:
			while loop_counter != 20:
				deck_reference.animate_card_to_position(temp_card, deck_card_slot_array[deck_card_slot_index-loop_counter].position)
				#Checks to see if its taking over an occupied spot
				if deck_card_slot_reference[deck_card_slot_index-loop_counter] == null:
					deck_card_slot_reference.remove_at(deck_card_slot_index-loop_counter)
					deck_card_slot_reference.insert(deck_card_slot_index-loop_counter, temp_card)
					deck_card_slot_array[deck_card_slot_index-loop_counter].card_in_slot = true
					print("I am Here 13")
					for i in deck_card_slot_array:
						print(i.card_in_slot)
					break
				else: 
					var second_temp = deck_card_slot_reference[deck_card_slot_index-loop_counter]
					deck_card_slot_reference.remove_at(deck_card_slot_index-loop_counter)
					deck_card_slot_reference.insert(deck_card_slot_index-loop_counter, temp_card)
					deck_card_slot_array[deck_card_slot_index-loop_counter].card_in_slot = true
					temp_card = second_temp
					loop_counter += 1
					print("I am Here 14")

		else:
			while loop_counter != 20:
				deck_reference.animate_card_to_position(temp_card, deck_card_slot_array[deck_card_slot_index+loop_counter].position)
				#Checks to see if its taking over an occupied spot
				if deck_card_slot_reference[deck_card_slot_index+loop_counter] == null:
					deck_card_slot_reference.remove_at(deck_card_slot_index+loop_counter)
					deck_card_slot_reference.insert(deck_card_slot_index+loop_counter, temp_card)
					deck_card_slot_array[deck_card_slot_index+loop_counter].card_in_slot = true
					print("I am Here 15")
					break
				else: 
					var second_temp = deck_card_slot_reference[deck_card_slot_index+loop_counter]
					deck_card_slot_reference.remove_at(deck_card_slot_index+loop_counter)
					deck_card_slot_reference.insert(deck_card_slot_index+loop_counter, temp_card)
					deck_card_slot_array[deck_card_slot_index+loop_counter].card_in_slot = true
					temp_card = second_temp
					loop_counter += 1
					print("I am Here 16")
	else:
		var temp_card = deck_card_slot_reference[deck_card_slot_index]
		deck_reference.animate_card_to_position(card_being_dragged, deck_card_slot_array[deck_card_slot_index].position)
		deck_card_slot_reference.remove_at(deck_card_slot_index)
		deck_card_slot_reference.insert(deck_card_slot_index, card_being_dragged)
		inventory_reference.animate_card_to_position(temp_card, inventory_card_slot_array[inventory_card_slot_reference_index].position)
		inventory_card_slot_reference.remove_at(inventory_card_slot_reference_index)
		inventory_card_slot_reference.insert(inventory_card_slot_reference_index, temp_card)
		print("I am Here 17")

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

func deck_to_inventory_swap(card_being_dragged, inventory_slot):
	var inventory_full = true
	for i in inventory_card_slot_array:
		if i.card_in_slot == false:
			inventory_full = false
	
	var null_index= inventory_card_slot_reference.find(null)

	if !inventory_full:
		card_being_dragged.position = inventory_slot.position
		inventory_slot.card_in_slot = true 
		
		#true card_being_dragged to the right
		var direction_shift = true
		if inventory_card_slot_index < null_index:
			direction_shift = false
			
		var loop_counter = 0
		var temp_card = card_being_dragged
		if deck_card_slot_reference_index >= 0:
			deck_card_slot_reference[deck_card_slot_reference_index] = null
			deck_card_slot_array[deck_card_slot_reference_index].card_in_slot = false
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
		var temp_card = inventory_card_slot_reference[inventory_card_slot_index]
		inventory_reference.animate_card_to_position(card_being_dragged, inventory_card_slot_array[inventory_card_slot_index].position)
		inventory_card_slot_reference.remove_at(inventory_card_slot_index)
		inventory_card_slot_reference.insert(inventory_card_slot_index, card_being_dragged)
		deck_reference.animate_card_to_position(temp_card, deck_card_slot_array[deck_card_slot_reference_index].position)
		deck_card_slot_reference.remove_at(deck_card_slot_reference_index)
		deck_card_slot_reference.insert(deck_card_slot_reference_index, temp_card)
		print("I am Here 12")

func sell_card(card):
	Global.player_gold += card.card_stats.sell_price
	
	if inventory_card_slot_reference_index >= 0:
		inventory_card_slot_reference[inventory_card_slot_reference_index] = null
		inventory_card_slot_array[inventory_card_slot_reference_index].card_in_slot = false
	if deck_card_slot_reference_index >= 0:
		deck_card_slot_reference[deck_card_slot_reference_index] = null
		deck_card_slot_array[deck_card_slot_reference_index].card_in_slot = false
	
	card.queue_free()
	update_player_gold()

func update_player_gold():
	$"../CanvasLayer/ColorRect/PlayerUI".change_player_gold() 

func card_reset():
	card_being_dragged.get_node("CardUI").mouse_filter = Control.MOUSE_FILTER_STOP
	card_being_dragged.scale = Vector2(1, 1)
	card_being_dragged.z_index = 1
	card_being_dragged = null

func on_hovered_over(card):
	if card == null: return
	if card_being_dragged and hover_on_upgrade_test == true: return
	card.mouse_exit = false
	card.scale = Vector2(1.1, 1.1)
	$"../TooltipTimer".start()
	await $"../TooltipTimer".timeout
	if card == null: return
	if card.mouse_exit or card_being_dragged: return
	card.scale = Vector2(2, 2)
	card.toggle_tooltip_show()
	card.z_index = 2
