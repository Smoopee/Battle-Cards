extends Node2D

const COLLISION_MASK_CARD = 1

var screen_size
var is_hoovering_on_card
var card_being_dragged
var card_selector_reference

func _ready():
	screen_size = get_viewport_rect().size
	card_selector_reference = $CardSelector

func _process(delta):
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), 
			clamp(mouse_pos.y, 0, screen_size.y))

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var card = raycast_check_for_card()
			if card:
				start_drag(card)
		else:
			if card_being_dragged:
				finish_drag()

func finish_drag():
	card_being_dragged.scale = Vector2(1.05, 1.05)
	card_selector_reference.add_card_to_hand(card_being_dragged)

func start_drag(card):
	card_being_dragged = card
	card.scale = Vector2(1, 1)

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
