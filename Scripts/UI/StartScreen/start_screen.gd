extends Node2D

const COLLISION_MASK_CARD_SELECTOR = 16
const COLLISION_MASK_NEW_GAME = 2
const COLLISION_MASK_LOAD_GAME = 4

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
			var card = raycast_check_for_card_selector()
			if card:
				start_drag(card)
		else:
			if card_being_dragged:
				finish_drag()

func start_drag(card):
	card_being_dragged = card
	card.scale = Vector2(1, 1)

func finish_drag():
	card_being_dragged.scale = Vector2(1.05, 1.05)
	var new_game = raycast_check_for_new_game()
	var load_game = raycast_check_for_load_game()
	
	if new_game:
		card_being_dragged.position = new_game.position
		card_being_dragged.get_node("Area2D").collision_layer = 8
		card_being_dragged = null
		new_game_function()
		
	elif load_game:
		card_being_dragged.position = load_game.position
		card_being_dragged.get_node("Area2D").collision_layer = 8
		card_being_dragged = null
		
		await get_tree().create_timer(2).timeout
		print("Let's Continue")
		get_tree().change_scene_to_file("res://Scenes/UI/Intermission/intermission.tscn")
	else:
		card_selector_reference.animate_card_to_position(card_being_dragged, card_being_dragged.home_position)
		card_being_dragged = null

func new_game_function():

	Global.player_inventory = []
	Global.player_deck = []
	Global.player_gold = 100
	Global.player_xp = 0
	Global.player_level = 1
	Global.player_class = ""
	Global.player_talent_array = []
	Global.battle_tracker = 1
	Global.player_skills = []
	Global.player_consumables = []
	Global.player_runes = []
	Global.set_player_inventory()
	Global.instantiate_player_inventory()
	Global.set_player_deck()
	Global.instantiate_player_deck()
	
	print("Let's Begin")
	await get_tree().create_timer(2).timeout
	
	get_tree().change_scene_to_file("res://Scenes/UI/ClassSelection/class_selection.tscn")

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
		card.scale = Vector2(1.05, 1.05)
		card.z_index = 2
	else:
		card.scale = Vector2(1, 1)
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

func raycast_check_for_new_game():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_NEW_GAME
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null 
	
func raycast_check_for_load_game():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_LOAD_GAME
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
