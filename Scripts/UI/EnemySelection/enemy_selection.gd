extends Node2D


const COLLISION_MASK_CARD_SELECTOR = 16
const COLLISION_MASK_ENEMY = 32

@onready var player_inventory = $PlayerInventoryScreen
var screen_size
var is_hoovering_on_card
var card_being_dragged
var card_selector_reference

var enemy_selection_screen = true
var current_screen = ""

func _ready():
	screen_size = get_viewport_rect().size
	card_selector_reference = $CardSelector

func _process(delta):
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), 
			clamp(mouse_pos.y, 0, screen_size.y))

func _input(event):
	if event.is_action_pressed("Inventory"):
		toggle_inventory()
	
	if !enemy_selection_screen: return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var enemy = raycast_check_for_enemy()
			var card = raycast_check_for_card_selector()
			if card:
				start_drag(card)
			if enemy:
				display_enemy_cards(enemy)
		else:
			if card_being_dragged:
				finish_drag()

func finish_drag():
	card_being_dragged.scale = Vector2(1.05, 1.05)
	var enemy_found = raycast_check_for_enemy()
	
	if enemy_found:
		enemy_loader(enemy_found)
		inventory_and_deck_save()
		Global.save_function()
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
	$PlayerInventoryScreen.visible = true
	$PlayerInventoryScreen.inventory_screen = true
	enemy_selection_screen = false
	$CanvasLayer/VBoxContainer/Inventory.visible = false
	$CanvasLayer/VBoxContainer/Talent.visible = false
	$CanvasLayer/VBoxContainer/Menu.visible = false
	$CanvasLayer/VBoxContainer/Back.visible = true
	current_screen = "inventory"


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

func display_enemy_cards(enemy):
	for i in $EnemyDeckDisplay.get_children():
		i.queue_free()
	$EnemyDeckDisplay.create_enemy_cards(enemy)

func _on_talent_button_down():
	$TalentTree.visible = true
	enemy_selection_screen = false
	$CanvasLayer/VBoxContainer/Inventory.visible = false
	$CanvasLayer/VBoxContainer/Talent.visible = false
	$CanvasLayer/VBoxContainer/Menu.visible = false
	$CanvasLayer/VBoxContainer/Back.visible = true
	current_screen = "talents"


func _on_back_button_down():
	match(current_screen):
		"inventory":
			$PlayerInventoryScreen.visible = false
			$PlayerInventoryScreen.inventory_screen = false
		"talents":
			$TalentTree.visible = false

	$CanvasLayer/VBoxContainer/Inventory.visible = true
	$CanvasLayer/VBoxContainer/Talent.visible = true
	$CanvasLayer/VBoxContainer/Menu.visible = true
	$CanvasLayer/VBoxContainer/Back.visible = false
	enemy_selection_screen = true

func connect_card_signals(card):
	card.connect("hovered_on", on_hovered_over)
	card.connect("hovered_off", on_hovered_off)

func on_hovered_over(card):
	if card_being_dragged: return
	card.mouse_exit = false
	card.scale = Vector2(1.1, 1.1)
	$TooltipTimer.start()
	await $TooltipTimer.timeout
	if card == null: return
	if card.mouse_exit or card_being_dragged: return
	card.toggle_tooltip_show()
	card.scale = Vector2(2, 2)
	card.z_index = 2

func on_hovered_off(card):
	if card_being_dragged: return
	card.mouse_exit = true
	card.toggle_tooltip_hide()
	card.scale = Vector2(1, 1)
	card.z_index = 1

func toggle_inventory():
	#From player screen to Inventory
	if $Player.visible == true:
		$PlayerInventoryScreen.visible = true
		$PlayerInventoryScreen/InventorySlots.visible = true
		$PlayerInventoryScreen/CurrentInventory.visible = true
		$PlayerInventoryScreen/DeckCardSlots.visible = true
		$PlayerInventoryScreen/ActiveDeck.visible = true
		$CardSelector.visible = false
		$Player.visible = false
		for i in $PlayerInventoryScreen.inventory_card_slot_reference:
			if i == null: continue
			i.visible = true
			i.enable_collision()
		for i in $PlayerInventoryScreen.deck_card_slot_reference:
			if i == null: continue
			i.visible = true
			i.enable_collision()
		$CardSelector.process_mode = Node.PROCESS_MODE_DISABLED
		$PlayerInventoryScreen/InventorySlots.process_mode = Node.PROCESS_MODE_INHERIT
		$PlayerInventoryScreen/DeckCardSlots.process_mode = Node.PROCESS_MODE_INHERIT
	#From Inventory to Player Screen
	else:
		$PlayerInventoryScreen/InventorySlots.visible = false
		$PlayerInventoryScreen/DeckCardSlots.visible = false
		$PlayerInventoryScreen/ActiveDeck.visible = false
		$PlayerInventoryScreen/CurrentInventory.visible = false
		$CardSelector.visible = true
		$Player.visible = true
		for i in $PlayerInventoryScreen.inventory_card_slot_reference:
			if i == null: continue
			i.visible = false
			i.disable_collision()
		for i in $PlayerInventoryScreen.deck_card_slot_reference:
			if i == null: continue
			i.visible = false
			i.disable_collision()
		$CardSelector.process_mode = Node.PROCESS_MODE_INHERIT
		$PlayerInventoryScreen/InventorySlots.process_mode = Node.PROCESS_MODE_DISABLED
		$PlayerInventoryScreen/DeckCardSlots.process_mode = Node.PROCESS_MODE_DISABLED
