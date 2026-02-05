extends Node2D

const COLLISION_MASK_PLAYER_CONSUMABLE = 2048
const COLLISION_MASK_PLAYER_SKILL = 256
const COLLISION_MASK_PLAYER_CARD = 1


var click_timer = 0.0
var is_dragging = false
var found_object
var previous_position

func _process(delta):
	if is_dragging: click_timer += 1 * delta # Increments while pressing
	else: click_timer = 0.0 # Reset when not pressing

func _input(event):
	var click_threshold: float = 0.2
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			print("2")
			for i in get_tree().get_nodes_in_group("focus object"):
				i.remove_from_group("focus object")
				i.toggle_tooltip_hide()
			if raycast_check_for_skill(): found_object = raycast_check_for_skill()
			if raycast_check_for_consumable(): found_object = raycast_check_for_consumable()
			if raycast_check_for_card(): found_object = raycast_check_for_card()
			print(found_object)
			if found_object:
				is_dragging = true
				previous_position = found_object.global_position
		elif event.is_released():
			if is_dragging:
				if click_timer < click_threshold: # Considered a click
					found_object.global_position = previous_position
					found_object.toggle_tooltip_show()
					found_object.add_to_group("focus object")
					is_dragging = false
					print(found_object)
					found_object = null
					return
				is_dragging = false
			found_object = null

func raycast_check_for_skill():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_PLAYER_SKILL
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null 

func raycast_check_for_consumable():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_PLAYER_CONSUMABLE
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null 

func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null 
