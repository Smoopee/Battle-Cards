extends Node2D

const COLLISION_MASK_CONSUMABLE = 2048
const COLLISION_MASK_PLAYER = 8
const COLLISION_MASK_ENEMY = 128
const COLLISION_MASK_PLAYER_CARD = 1
const COLLISION_MASK_ENEMY_CARD = 64


var consumable_offset = 0
var center_screen_x
var screen_size
var consumable_being_dragged
var consumable_slots = []
var consumable_used = false
var consumable_leftover = false
var consumable_previous_position
var place_holder_used = false

func _ready():
	center_screen_x = get_viewport().size.x / 2
	screen_size = get_viewport_rect().size

func _process(delta):
	if consumable_being_dragged:
		var mouse_pos = get_global_mouse_position()
		consumable_being_dragged.global_position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), 
			clamp(mouse_pos.y, 0, screen_size.y)) 

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var consumable = raycast_check_for_consumable()
			if consumable:
				start_drag(consumable)
		else:
			if consumable_being_dragged:
				finish_drag()

func start_drag(consumable):
	consumable_being_dragged = consumable
	start_drag_stack_check()
	consumable.z_index = 2
	consumable.scale = Vector2(1.5, 1.5)
	consumable_previous_position = consumable.global_position
	consumable.toggle_info_ui(false)

func finish_drag():
	consumable_used = false
	consumable_leftover = false
	
	print("in consumable manager")

	
	var raycast_object
	if raycast_check_for_player_card(): raycast_object = raycast_check_for_player_card()
	elif raycast_check_for_enemy_card(): raycast_object = raycast_check_for_enemy_card()
	elif raycast_check_for_player(): raycast_object = raycast_check_for_player()
	elif raycast_check_for_enemy(): raycast_object = raycast_check_for_enemy()
	
	if raycast_object: use_consumable(raycast_object)
	
	if consumable_leftover:
		print("in consumable leftover")
		consumable_being_dragged.global_position = consumable_previous_position
		consumable_reset()
		consumable_used = true
	
	if !consumable_used: 
		print("in consumable not used")
		animate_consumable_back_to_position(consumable_being_dragged, consumable_previous_position)
		consumable_reset()
	
	if place_holder_used and consumable_used:
		print("in place holder used")
		for i in get_children():
			remove_child(i)
			i.queue_free()
		place_holder_used = false


func raycast_check_for_consumable():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CONSUMABLE
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null 

func raycast_check_for_player_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_PLAYER_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null 

func raycast_check_for_player():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_PLAYER
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
	parameters.collision_mask = COLLISION_MASK_ENEMY_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null 

func consumable_reset():
	print("in consumable reset")
	consumable_being_dragged.scale = Vector2(1, 1)
	consumable_being_dragged.update_stack_ui()
	consumable_being_dragged.toggle_info_ui(true)
	consumable_being_dragged = null

func animate_consumable_back_to_position(consumable, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(consumable, "global_position", new_position, 0.1)
	tween.tween_property(consumable, "z_index", 1, 0)
	if place_holder_used:
		await tween.finished
		print("in place holder used")
		for i in get_children():
			remove_child(i)
			i.queue_free()
		place_holder_used = false

func consumable_stack_check():
	print("consumable stat check")
	if consumable_being_dragged.consumable_stats.stack_amount >= 2:
		consumable_being_dragged.consumable_stats.stack_amount -= 1
		consumable_leftover = true
		return true
	else: return false

func on_consumable_use():
	print("on consumable use")
	consumable_being_dragged.queue_free()
	consumable_being_dragged = null
	consumable_used = true


func use_consumable(target):
	print("use consumable")
	if target.is_in_group(consumable_being_dragged.consumable_stats.target):
		if consumable_being_dragged.consumable_effect(target):
			if !consumable_stack_check(): on_consumable_use()

func start_drag_stack_check():
	print("start drag check")
	if consumable_being_dragged.consumable_stats.stack_amount >= 2:
		var place_holder = load(consumable_being_dragged.consumable_stats.consumable_scene_path).instantiate()
		place_holder.global_position = consumable_being_dragged.global_position
		place_holder.consumable_stats = consumable_being_dragged.consumable_stats.duplicate()
		place_holder.consumable_stats.stack_amount -= 1
		place_holder.update_stack_ui()
		place_holder.toggle_info_ui(true)
		add_child(place_holder)
		place_holder_used = true
		print("start drag check is true")

