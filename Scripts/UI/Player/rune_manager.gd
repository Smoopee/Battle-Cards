extends Node2D

const COLLISION_MASK_CONSUMABLE = 32768
const COLLISION_MASK_PLAYER = 8
const COLLISION_MASK_ENEMY = 128



var rune_offset = 0
var center_screen_x
var screen_size
var rune_being_dragged
var rune_slots = []
var rune_previous_position


func _ready():
	center_screen_x = get_viewport().size.x / 2
	screen_size = get_viewport_rect().size

func _process(delta):
	if rune_being_dragged:
		var mouse_pos = get_global_mouse_position()
		rune_being_dragged.global_position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), 
			clamp(mouse_pos.y, 0, screen_size.y)) 

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var rune = raycast_check_for_rune()
			if rune:
				if rune.rune_stats.attached != true:
					start_drag(rune)
		else:
			if rune_being_dragged:
				finish_drag()

func start_drag(rune):
	rune_being_dragged = rune
	rune.z_index = 2
	rune.scale = Vector2(1.5, 1.5)
	rune_previous_position = rune.global_position

func finish_drag():
	print("in rune manager")
	
	if raycast_check_for_enemy():
		var enemy = raycast_check_for_enemy()
		enemy.add_rune(rune_being_dragged.rune_name)
		rune_being_dragged.queue_free()
		rune_reset()
		return
	
	animate_rune_back_to_position(rune_being_dragged, rune_previous_position)
	rune_reset()

func raycast_check_for_rune():
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

func rune_reset():
	print("in rune reset")
	rune_being_dragged.scale = Vector2(1, 1)
	rune_being_dragged = null

func animate_rune_back_to_position(rune, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(rune, "global_position", new_position, 0.1)
	tween.tween_property(rune, "z_index", 0, 0)



func use_rune(target):
	print("use rune")
	
