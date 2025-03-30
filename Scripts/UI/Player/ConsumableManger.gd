extends Node2D

const COLLISION_MASK_CONSUMABLE = 2048
const COLLISION_MASK_PLAYER = 8


var consumable_offset = 0
var center_screen_x
var screen_size
var consumable_being_dragged
var consumable_slots = []
var consumable_used = false
var consumable_previous_position
var drag_correction

func _ready():
	center_screen_x = get_viewport().size.x / 2
	screen_size = get_viewport_rect().size
	drag_correction = Vector2(-center_screen_x, -800)

func _process(delta):
	if consumable_being_dragged:
		var mouse_pos = get_global_mouse_position()
		consumable_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), 
			clamp(mouse_pos.y, 0, screen_size.y)) + drag_correction

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
	consumable.z_index = 2
	consumable.scale = Vector2(1.5, 1.5)
	consumable_previous_position = consumable.position

func finish_drag():

	var player = raycast_check_for_player()
	if player:
		if player.is_in_group(consumable_being_dragged.consumable_stats.target):
			consumable_being_dragged.consumable_effect()
			consumable_being_dragged.queue_free()
			consumable_being_dragged = null
			consumable_used = true
			
	if !consumable_used: 
		animate_consumable_back_to_position(consumable_being_dragged, consumable_previous_position)
		consumable_reset()

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

func consumable_reset():
	consumable_being_dragged.scale = Vector2(1, 1)
	consumable_being_dragged.z_index = 1
	consumable_being_dragged = null

func animate_consumable_back_to_position(consumable, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(consumable, "position", new_position, 0.1)
