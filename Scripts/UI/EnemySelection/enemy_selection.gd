extends Node2D


const COLLISION_MASK_CARD_SELECTOR = 16
const COLLISION_MASK_ENEMY = 128
const COLLISION_MASK_BIOME = 32

@onready var player_inventory = $PlayerInventoryScreen
var screen_size
var is_hoovering_on_card
var card_being_dragged
var card_selector_reference
var is_toggle_inventory = false

var glow_power = 3.0
var speed = 2.0


func _ready():
	screen_size = get_viewport_rect().size
	card_selector_reference = $CardSelector
	toggle_inventory()

func _process(delta):
	if card_being_dragged:
		glow_pulse(delta)
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), 
			clamp(mouse_pos.y, 0, screen_size.y))

func _input(event):
	if event.is_action_pressed("Inventory"):
		toggle_inventory()
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			$TooltipTimer.stop()
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
	var biome_found = raycast_check_for_biome()
	
	if biome_found:
		$Biomes.clear_biomes()
		$EnemyOrganizer.enemy_setup(biome_found.name)

	if enemy_found:
		enemy_loader(enemy_found)
		inventory_and_deck_save()
		Global.player_consumables = get_tree().get_first_node_in_group("player consumables").get_consumable_array()
		Global.player_runes = get_tree().get_first_node_in_group("player runes").get_rune_array()
		Global.save_function()
		Global.current_scene = "battle_sim"
		get_tree().change_scene_to_file("res://Scenes/Battle/berserker_battle_sim.tscn")
	else:
		card_selector_reference.animate_card_to_position(card_being_dragged, card_being_dragged.home_position)
		card_being_dragged = null
		stop_card_glow()

func start_drag(card):
	card_being_dragged = card
	card.scale = Vector2(1, 1)
	start_card_glow()

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

func raycast_check_for_biome():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_BIOME
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
	Global.current_enemy = enemy.character_stats


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

func start_card_glow():
	for i in $Biomes.get_children():
		i.get_node("GlowEffect").visible = true

func stop_card_glow():
	for i in $Biomes.get_children():
		i.get_node("GlowEffect").visible = false

func glow_pulse(delta):
	for i in $Biomes.get_children():
		glow_power += delta * speed
		if glow_power >= 2.0 and speed > 0 or glow_power <= 1.0 and speed < 0:
			speed *= -1.0
		i.get_node("GlowEffect").modulate.a = glow_power/ 4
		i.get_node("GlowEffect").get_material().set_shader_parameter("glow_power", glow_power)
