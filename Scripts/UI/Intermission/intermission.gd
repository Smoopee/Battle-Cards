extends Node2D


const COLLISION_MASK_CARD_SELECTOR = 16
const COLLISION_MASK_MERCHANT = 32

@onready var player_inventory = $PlayerInventoryScreen
var screen_size
var card_being_dragged
var card_selector_reference

var intermission_screen = true
var current_screen = ""

func _ready():
	screen_size = get_viewport_rect().size
	card_selector_reference = $CardSelector
	Global.intermission_tracker += 1

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
	var merchant_found = raycast_check_for_merchant()
	
	if merchant_found:
		Global.current_merchant = merchant_found.merchant_scene_path
		inventory_and_deck_save()
		Global.save_function()
		get_tree().change_scene_to_file(("res://Scenes/UI/Shop/shop.tscn"))
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

func get_card_with_highest_z_index(cards):
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	
	for i in range(1, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card


func _on_inventory_button_button_down():
	$PlayerInventoryScreen.visible = true
	$PlayerInventoryScreen.inventory_screen = true
	intermission_screen = false
	$CanvasLayer/VBoxContainer/InventoryButton.visible = false
	$CanvasLayer/VBoxContainer/TalentButton.visible = false
	$CanvasLayer/VBoxContainer/MenuButton.visible = false
	$CanvasLayer/VBoxContainer/BackButton.visible = true
	current_screen = "inventory"

func _on_talent_button_button_down():
	$TalentTree.visible = true
	intermission_screen = false
	$CanvasLayer/VBoxContainer/InventoryButton.visible = false
	$CanvasLayer/VBoxContainer/TalentButton.visible = false
	$CanvasLayer/VBoxContainer/MenuButton.visible = false
	$CanvasLayer/VBoxContainer/BackButton.visible = true
	current_screen = "talents"


func inventory_and_deck_save():
	var temp_inventory = []
	for i in player_inventory.inventory_card_slot_reference:
		if i != null:
			temp_inventory.push_back(i.card_stats)
		else:
			temp_inventory.push_back(null)
	Global.player_inventory = temp_inventory

	var temp_deck = []
	for i in player_inventory.deck_card_slot_reference:
		if i != null:
			temp_deck.push_back(i.card_stats)
		else:
			temp_deck.push_back(null)
	Global.player_deck = temp_deck


func _on_skip_button_button_down():
	Global.player_gold += 5
	inventory_and_deck_save()
	Global.save_function()
	if Global.intermission_tracker <= 1: 
		Global.intermission_tracker += 1
		get_tree().change_scene_to_file("res://Scenes/UI/Intermission/intermission.tscn")
	else:
		Global.intermission_tracker = 0
		get_tree().change_scene_to_file("res://Scenes/UI/EnemySelection/enemy_selection.tscn")


func _on_back_button_button_down():
	match(current_screen):
		"inventory":
			$PlayerInventoryScreen.visible = false
			$PlayerInventoryScreen.inventory_screen = false
		"talents":
			$TalentTree.visible = false

	$CanvasLayer/VBoxContainer/InventoryButton.visible = true
	$CanvasLayer/VBoxContainer/TalentButton.visible = true
	$CanvasLayer/VBoxContainer/MenuButton.visible = true
	$CanvasLayer/VBoxContainer/BackButton.visible = false
	intermission_screen = true
