extends Node2D

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_CARD_SLOT = 2

var screen_size
var card_being_dragged
var is_hoovering_on_card
var inventory_reference

var card_slot_array = []
var card_slot_reference = []


func _ready():
	screen_size = get_viewport_rect().size
	inventory_reference = $"../Inventory"
	
	for i in $"../CardSlots".get_children():
		card_slot_array.push_front(i)
	
	card_slot_reference = $"../Inventory".card_slot_reference


func _process(delta):
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), 
			clamp(mouse_pos.y, 0, screen_size.y))

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var card = raycast_check_for_card()
			if card and card.is_players:
				start_drag(card)
		else:
			if card_being_dragged:
				finish_drag()

func start_drag(card):
	card_being_dragged = card
	card.scale = Vector2(1, 1)

func finish_drag():
	card_being_dragged.scale = Vector2(1.05, 1.05)
	var card_slot_found = raycast_check_for_card_slot()
	var card_slot_index = card_slot_array.find(card_slot_found)
	var card_slot_reference_index = card_slot_reference.find(card_being_dragged)
	var card_being_replaced
	var previous_card_slot
	
	
	if card_slot_reference_index  > -1 and card_slot_found != null:
		previous_card_slot = card_slot_reference_index
		if card_slot_found.card_in_slot:
			card_being_replaced = card_slot_reference[card_slot_index]
			
		card_slot_reference[card_slot_reference_index] = null
		card_slot_array[card_slot_reference_index].card_in_slot = false
	
	if card_slot_found and not card_slot_found.card_in_slot:
		inventory_reference.remove_card_from_hand(card_being_dragged)
		card_being_dragged.position = card_slot_found.position
		card_slot_found.card_in_slot = true
		card_slot_reference.remove_at(card_slot_index)
		card_slot_reference.insert(card_slot_index, card_being_dragged)
	elif card_slot_found and card_slot_found.card_in_slot:
		inventory_reference.remove_card_from_hand(card_being_dragged)
		card_being_dragged.position = card_slot_found.position
		card_slot_found.card_in_slot = true 
		
		if card_slot_reference_index > -1:
			#true for a down shift
			var direction_shift = true
			if card_slot_index < previous_card_slot:
				direction_shift = false
				
			var loop_counter = 0
			var temp_card = card_being_dragged
			if direction_shift:
				while loop_counter != 20:
					inventory_reference.animate_card_to_position(temp_card, card_slot_array[card_slot_index-loop_counter].position)
					#Checks to see if its taking over an occupied spot
					if card_slot_reference[card_slot_index-loop_counter] == null:
						card_slot_reference.remove_at(card_slot_index-loop_counter)
						card_slot_reference.insert(card_slot_index-loop_counter, temp_card)
						card_slot_array[card_slot_index-loop_counter].card_in_slot = true
						break
					else: 
						var second_temp = card_slot_reference[card_slot_index-loop_counter]
						card_slot_reference.remove_at(card_slot_index-loop_counter)
						card_slot_reference.insert(card_slot_index-loop_counter, temp_card)
						card_slot_array[card_slot_index-loop_counter].card_in_slot = true
						temp_card = second_temp
						loop_counter += 1
						
			else:
				while loop_counter != 20:
					inventory_reference.animate_card_to_position(temp_card, card_slot_array[card_slot_index+loop_counter].position)
					#Checks to see if its taking over an occupied spot
					if card_slot_reference[card_slot_index+loop_counter] == null:
						card_slot_reference.remove_at(card_slot_index+loop_counter)
						card_slot_reference.insert(card_slot_index+loop_counter, temp_card)
						card_slot_array[card_slot_index+loop_counter].card_in_slot = true
						break
					else: 
						var second_temp = card_slot_reference[card_slot_index+loop_counter]
						card_slot_reference.remove_at(card_slot_index+loop_counter)
						card_slot_reference.insert(card_slot_index+loop_counter, temp_card)
						card_slot_array[card_slot_index-loop_counter+1].card_in_slot = true
						temp_card = second_temp
						loop_counter += 1
		else:
			inventory_reference.add_card_to_hand(card_slot_reference[card_slot_index])
			card_slot_reference.remove_at(card_slot_index)
			card_slot_reference.insert(card_slot_index, card_being_dragged)
	else: 
		inventory_reference.add_card_to_hand(card_being_dragged)
		if card_slot_reference_index  > -1:
			card_slot_reference[card_slot_reference_index] = null
			card_slot_array[card_slot_reference_index].card_in_slot = false

	card_being_dragged = null

func connect_card_signals(card):
	card.connect("hoovered", on_hoovered_over_card)
	card.connect("hoovered_off", on_hoovered_off_card)

func on_hoovered_over_card(card):
	if !is_hoovering_on_card:
		is_hoovering_on_card = true
		highlight_card(card, true)

func on_hoovered_off_card(card):
	if !card_being_dragged:
		highlight_card(card, false)
		var new_card_hoovered = raycast_check_for_card()
		if new_card_hoovered:
			highlight_card(new_card_hoovered, true)
		else: 
			is_hoovering_on_card = false

func highlight_card(card, hoovered):
	if hoovered:
		card.scale = Vector2(1.05, 1.05)
		card.z_index = 2
	else:
		card.scale = Vector2(1, 1)
		card.z_index = 1

func raycast_check_for_card_slot():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD_SLOT
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
		return get_card_with_highest_z_index(result)
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


