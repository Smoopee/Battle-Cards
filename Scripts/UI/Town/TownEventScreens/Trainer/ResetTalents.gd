extends Node2D

const CARD_WIDTH = 250
const HAND_Y_POSITION = 400
const COLLISION_MASK_MERCHANT_CARD = 64
const COLLISION_MASK_PLAYER = 8

var card_being_dragged
var screen_size
var card_previous_position

func setup():
	screen_size = get_viewport_rect().size
	var reset_talent_card = load("res://Scenes/UI/Town/TownEventScreens/Trainer/reset_talents.tscn").instantiate()
	add_child(reset_talent_card)
	reset_talent_card.get_node("Area2D").collision_mask = 64
	reset_talent_card.get_node("Area2D").collision_layer = 64
	reset_talent_card.position = Vector2(get_viewport().size.x / 2, HAND_Y_POSITION)

func _process(delta):
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), 
			clamp(mouse_pos.y, 0, screen_size.y))

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var merchant_card = raycast_check_for_merchant_card()
			if merchant_card:
				start_drag_card(merchant_card)
		else:
			if card_being_dragged:
				finish_drag_card()

func start_drag_card(card):
	card_being_dragged = card
	card_being_dragged.scale = Vector2(1.1, 1.1)
	card_being_dragged.z_index = 2
	card_previous_position = card.position

func finish_drag_card():
	if raycast_check_for_player(): reset_talents()
	
	animate_card_to_position(card_being_dragged, card_previous_position)
	card_reset()


func raycast_check_for_merchant_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_MERCHANT_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return get_card_with_highest_z_index(result)
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

func get_card_with_highest_z_index(cards):
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	
	for i in range(1, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card

func reset_talents():
	if Global.player_gold < 40:
		animate_card_to_position(card_being_dragged, card_previous_position)
		print("Not enough gold")
		return
	Global.player_gold -= 40
	card_being_dragged.queue_free()
	get_tree().get_first_node_in_group("talent tree").reset_talents()
	update_player_gold()
	get_tree().get_first_node_in_group("bottom ui").toggle_talent_screen()
	return

func update_player_gold():
	get_tree().get_first_node_in_group("bottom ui").change_player_gold() 

func card_reset():
	card_being_dragged.scale = Vector2(1, 1)
	card_being_dragged.z_index = 1
	card_being_dragged = null

func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1)
