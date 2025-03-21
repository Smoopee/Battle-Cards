extends Node2D

const COLLISION_MASK_CONSUMABLE = 16
const COLLISION_MASK_PLAYER = 8
const CONSUMABLE_Y_POSITION = 820


var consumable_offset = 0
var center_screen_x
var screen_size
var consumable_being_dragged
var consumable_slots = []

func _ready():
	center_screen_x = get_viewport().size.x / 2
	screen_size = get_viewport_rect().size
	
	var test = load("res://Scenes/Consumables/battery.tscn").instantiate()
	var test2 = load("res://Scenes/Consumables/herb.tscn").instantiate()
	add_child(test2)
	add_child(test)
	consumable_slots.push_back(test)
	consumable_slots.push_back(test2)
	organize_consumables()


func _process(delta):
	if consumable_being_dragged:
		var mouse_pos = get_global_mouse_position()
		if consumable_being_dragged != null:
			consumable_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), 
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
	consumable.scale = Vector2(1.5, 1.5)

func finish_drag():
	if raycast_check_for_player():
		use_consumable(consumable_being_dragged)
		consumable_being_dragged.queue_free()
		organize_consumables()
		consumable_being_dragged = null

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
		return result[0]
	return null 

func organize_consumables():
	consumable_offset = 0
	for i in consumable_slots:
		i.position = Vector2(center_screen_x - 120, CONSUMABLE_Y_POSITION + consumable_offset )
		consumable_offset += 30
	
	
func use_consumable(consumable):
	consumable.activate_consumable()
	if consumable in consumable_slots:
		consumable_slots.erase(consumable)

