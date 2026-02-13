extends Node2D

const COLLISION_MASK_PLAYER_CONSUMABLE = 2048
const COLLISION_MASK_PLAYER_SKILL = 256
const COLLISION_MASK_PLAYER_RUNE = 32768
const COLLISION_MASK_MERCHANT_SKILL = 512
const COLLISION_MASK_PLAYER_CARD = 1
const COLLISION_MASK_MERCHANT = 32
const ENEMY_CARD_COLLISION_LAYER = 64
const COLLISION_MASK_ENEMY = 128
const COLLISION_MASK_MERCHANT_CONSUMABLE = 8192
const COLLISION_MASK_PLAYER_ABILITY = 1048576
const COLLISION_MASK_BUFF_DEBUFF = 16777216


var click_timer = 0.0
var is_dragging = false
var found_object
var previous_position

var popup = false

func _process(delta):
	if is_dragging: click_timer += 1 * delta # Increments while pressing
	else: click_timer = 0.0 # Reset when not pressing
	
	if click_timer > 1 and previous_position.distance_to(get_global_mouse_position()) < 50:
		if !popup:
			found_object.toggle_tooltip_show(previous_position)
			found_object.add_to_group("focus object")
			is_dragging = false
			found_object = null
			popup = true

func _input(event):
	var click_threshold: float = 0.2
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			for i in get_tree().get_nodes_in_group("focus object"):
				i.remove_from_group("focus object")
				i.toggle_tooltip_hide()
			found_object = set_raycast_object()
			if found_object:
				is_dragging = true
				previous_position = found_object.global_position
				
				
		elif event.is_released():
			if is_dragging:
				if click_timer < click_threshold: # Considered a click
					if raycast_check_for_player_ability():
						raycast_check_for_player_ability().button_pressed()
						is_dragging = false
						found_object = null
						popup = false
						return
						
					found_object.toggle_tooltip_show(previous_position)
					found_object.add_to_group("focus object")
					is_dragging = false
					found_object = null
					popup = false
					return
				if click_timer > click_threshold  and previous_position.distance_to(get_global_mouse_position()) < 100:
					found_object.toggle_tooltip_show(previous_position)
					found_object.add_to_group("focus object")
					is_dragging = false
					found_object = null
					popup = false
				is_dragging = false
			found_object = null
			popup = false

func set_raycast_object():
	if raycast_check_for_skill(): return raycast_check_for_skill()
	if raycast_check_for_consumable(): return raycast_check_for_consumable()
	if raycast_check_for_player_rune(): return raycast_check_for_player_rune()
	if raycast_check_for_card(): return raycast_check_for_card()
	if raycast_check_for_merchant(): return raycast_check_for_merchant()
	if raycast_check_for_merchant_consumable(): return raycast_check_for_merchant_consumable()
	if raycast_check_for_merchant_skill(): return raycast_check_for_merchant_skill()
	if raycast_check_for_enemy(): return raycast_check_for_enemy()
	if raycast_check_for_enemy_card(): return raycast_check_for_enemy_card()
	if raycast_check_for_buff(): return raycast_check_for_buff()
	if raycast_check_for_player_ability(): return raycast_check_for_player_ability()
	
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

func raycast_check_for_merchant():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_MERCHANT
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null 

func raycast_check_for_merchant_consumable():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_MERCHANT_CONSUMABLE
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null 

func raycast_check_for_merchant_skill():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_MERCHANT_SKILL
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null 

func raycast_check_for_player_rune():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_PLAYER_RUNE
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null 

func raycast_check_for_player_ability():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_PLAYER_ABILITY
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null 

func raycast_check_for_enemy():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_ENEMY
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null 

func raycast_check_for_enemy_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = ENEMY_CARD_COLLISION_LAYER
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null 

func raycast_check_for_buff():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_BUFF_DEBUFF
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null 
