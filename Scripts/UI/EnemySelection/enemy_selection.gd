extends Node2D

var save_file_path = "user://SaveData/"
var save_file_name = "PlayerSave.tres"
var playerData = PlayerData.new()

const COLLISION_MASK_CARD_SELECTOR = 16
const COLLISION_MASK_ENEMY = 32

@onready var player_inventory = $PlayerInventoryScreen
var screen_size
var is_hoovering_on_card
var card_being_dragged
var card_selector_reference

func _ready():
	screen_size = get_viewport_rect().size
	card_selector_reference = $CardSelector
	verify_save_directory(save_file_path)

func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)

func save():
	ResourceSaver.save(playerData, save_file_path + save_file_name)
	print("save")

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
	card_being_dragged.scale = Vector2(1.05, 1.05)
	var enemy_found = raycast_check_for_enemy()
	
	if enemy_found:
		enemy_loader(enemy_found)
		inventory_and_deck_save()
		get_tree().change_scene_to_file(("res://Scenes/UI/deck_builder.tscn"))
	else:
		card_selector_reference.animate_card_to_position(card_being_dragged, card_being_dragged.home_position)
		card_being_dragged = null

func start_drag(card):
	card_being_dragged = card
	card.scale = Vector2(1, 1)

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

func get_card_with_highest_z_index(cards):
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	
	for i in range(1, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card

func enemy_loader(enemy):
	Global.current_enemy = enemy.enemy_stats
	Global.max_enemy_health = Global.current_enemy.health
	Global.enemy_health = Global.max_enemy_health

func _on_inventory_button_down():
	if !$PlayerInventoryScreen.visible:
		$PlayerInventoryScreen.visible = true
	else:
		$PlayerInventoryScreen.visible = false
		
	$CardSelector.card_selector_collision_toggle()
	
	$PlayerInventoryScreen.inventory_collision_toggle()

func inventory_and_deck_save():
	var temp_inventory = []
	for i in player_inventory.inventory_card_slot_reference:
		if i != null:
			temp_inventory.push_back(i.card_stats)
		else:
			temp_inventory.push_back(null)
	playerData.player_inventory = temp_inventory
	Global.player_inventory = temp_inventory

	var temp_deck = []
	for i in player_inventory.deck_card_slot_reference:
		if i != null:
			temp_deck.push_back(i.card_stats)
		else:
			temp_deck.push_back(null)
	playerData.player_deck = temp_deck
	Global.player_deck = temp_deck
	save()
