extends Node2D


const COLLISION_MASK_CARD_SELECTOR = 16
const COLLISION_CLASS_SELECTION = 8

var screen_size
var is_hoovering_on_card
var card_being_dragged
var card_selector_reference


func _ready():
	screen_size = get_viewport_rect().size
	card_selector_reference = $CardSelector
	$BerserkerSelection.position = Vector2(Global.center_screen_x + 300, 500)
	$BerserkerSelection2.position = Vector2(Global.center_screen_x, 500)
	$BerserkerSelection3.position = Vector2(Global.center_screen_x - 300, 500)

func _process(delta):
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), 
			clamp(mouse_pos.y, 0, screen_size.y))

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var card = raycast_check_for_card_selector()
			if card:
				start_drag(card)
		else:
			if card_being_dragged:
				finish_drag()

func finish_drag():
	card_being_dragged.scale = Vector2(1.05, 1.05) * Global.ui_scaler
	var class_selected = raycast_check_for_class_selection()
		
	if class_selected:
		
		Global.player_class = class_selected.set_class()
		Global.player_stats = load("res://Resources/Character/berserker.tres")
		Global.save_function()
		card_being_dragged.position = class_selected.position + Vector2(0, 120)
		card_being_dragged.get_node("Area2D").collision_layer = 8
		card_being_dragged = null
		
		print("Let's Continue")
		$fader.fade_screen(true, 3.0, func(): get_tree().change_scene_to_file("res://Scenes/UI/Intermission/intermission.tscn"))
	else:
		card_selector_reference.animate_card_to_position(card_being_dragged, card_being_dragged.home_position)
		card_being_dragged = null

func start_drag(card):
	card_being_dragged = card
	card.scale = Vector2(1, 1) * Global.ui_scaler

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
		var new_card_hoovered = raycast_check_for_card_selector()
		if new_card_hoovered:
			highlight_card(new_card_hoovered, true)
		else: 
			is_hoovering_on_card = false

func highlight_card(card, hoovered):
	if hoovered:
		card.scale = Vector2(1.05, 1.05) * Global.ui_scaler
		card.z_index = 2
	else:
		card.scale = Vector2(1, 1) * Global.ui_scaler
		card.z_index = 1

func raycast_check_for_card_selector():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD_SELECTOR
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return get_card_with_highest_z_index(result)
	return null 

func raycast_check_for_class_selection():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_CLASS_SELECTION
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
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
