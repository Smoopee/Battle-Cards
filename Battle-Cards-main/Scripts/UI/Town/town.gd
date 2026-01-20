extends Node2D


const COLLISION_MASK_CARD_SELECTOR = 16
const COLLISION_MASK_EVENT = 32

@onready var player_inventory = $PlayerInventoryScreen
var screen_size
var card_being_dragged
var card_selector_reference

var is_toggle_inventory = false

func _ready():
	screen_size = get_viewport_rect().size
	card_selector_reference = $CardSelector
	Global.intermission_tracker += 1
	toggle_inventory()


func _process(delta):
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), 
			clamp(mouse_pos.y, 0, screen_size.y))

func _input(event):
	if event.is_action_pressed("Inventory"):
		toggle_inventory()
		
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
	
	if raycast_check_for_event():
		get_tree().change_scene_to_file(raycast_check_for_event().event_scene_path)
		
	else:
		card_selector_reference.animate_card_to_position(card_being_dragged, card_being_dragged.home_position)
		card_being_dragged = null

func start_drag(card):
	card_being_dragged = card
	card.scale = Vector2(1, 1) * Global.ui_scaler

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

func raycast_check_for_event():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_EVENT
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
	Global.player_consumables = $Player/Berserker.get_consumable_array()
	Global.save_function()
	if Global.intermission_tracker <= 1: 
		Global.intermission_tracker += 1
		Global.current_scene = "intermission"
		get_tree().change_scene_to_file("res://Scenes/UI/Intermission/intermission.tscn")
	else:
		Global.intermission_tracker = 0
		Global.current_scene = "enemy_selection"
		get_tree().change_scene_to_file("res://Scenes/UI/EnemySelection/enemy_selection.tscn")

func connect_card_signals(card):
	card.connect("hovered_on", on_hovered_over)
	card.connect("hovered_off", on_hovered_off)

func on_hovered_over(card):
	if $PlayerInventoryScreen.card_being_dragged and $PlayerInventoryScreen.hover_on_upgrade_test == true: return
	if $ConsumableManger.consumable_being_dragged: return
	card.mouse_exit = false
	card.scale = Vector2(1.1, 1.1) * Global.ui_scaler
	$TooltipTimer.start()
	await $TooltipTimer.timeout
	if card == null: return
	if card.mouse_exit or card_being_dragged: return
	card.toggle_tooltip_show()
	card.scale = Vector2(2, 2) * Global.ui_scaler
	print("In intermision")
	card.z_index = 2

func on_hovered_off(card):
	if card_being_dragged: return
	card.mouse_exit = true
	card.toggle_tooltip_hide()
	card.scale = Vector2(1, 1) * Global.ui_scaler
	card.z_index = 1

func toggle_inventory():
	#From player screen to Inventory
	if is_toggle_inventory == true:
		$PlayerInventoryScreen.visible = true
		$CardSelector.visible = false
		$Player/Berserker.inventory_screen_toggle(true)
		$PlayerInventoryScreen.process_mode = Node.PROCESS_MODE_INHERIT
		$CardSelector.process_mode = Node.PROCESS_MODE_DISABLED
		is_toggle_inventory = false
	#From Inventory to Player Screen
	else:
		$PlayerInventoryScreen.visible = false
		$CardSelector.visible = true
		$Player/Berserker.inventory_screen_toggle(false)
		$CardSelector.process_mode = Node.PROCESS_MODE_INHERIT
		$PlayerInventoryScreen.process_mode = Node.PROCESS_MODE_DISABLED
		is_toggle_inventory = true
