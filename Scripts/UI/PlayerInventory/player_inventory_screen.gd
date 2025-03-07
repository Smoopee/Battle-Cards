extends Node2D

var playerData = PlayerData.new()

const CARD_WIDTH = 130
const HAND_Y_POSITION = 630
const CARD_SCENE_PATH = "res://Scenes/UI/card.tscn"
const COLLISION_MASK_CARD = 1


var card_being_dragged
var inventory_db = []
var inventory = []
var center_screen_x
var screen_size


func _ready():
	center_screen_x = get_viewport().size.x / 2
	screen_size = get_viewport_rect().size
	create_inventory()
	inventory_collision_toggle()
	

func _process(delta):
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), 
			clamp(mouse_pos.y, 0, screen_size.y))

#INVENTORY FUNCTIONS -------------------------------------------------------------------------------
func create_inventory():
	fetch_inventory()
	
	for i in range(inventory_db.size()):
		var card_scene = load(inventory_db[i].card_scene_path).instantiate()
		card_scene.card_stats = inventory_db[i]
		add_child(card_scene)
		add_card_to_hand(card_scene)
	
	var card_position = 0
	for i in inventory:
		i.upgrade_card(i.card_stats.upgrade_level)
		i.update_card_ui()
		i.card_stats.inventory_position = card_position
		i.card_stats.is_players = true
		card_position += 1

func fetch_inventory():
	inventory_db = Global.player_inventory

func add_card_to_hand(card):
	if card not in inventory:
		inventory.push_back(card)
		update_hand_positions()
	else:
		animate_card_to_position(card, card.card_stats.screen_position)

func update_hand_positions():
	for i in range(inventory.size()):
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		var card = inventory[i]
		card.card_stats.screen_position = new_position
		card.position = new_position
		
func calculate_card_position(index):
	var total_width = (inventory.size() - 1) * CARD_WIDTH
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2
	return x_offset

func remove_card_from_hand(card):
	if card in inventory:
		inventory.erase(card)
		update_hand_positions()

func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1)

#INPUT AND DRAG FUNCTIONS---------------------------------------------------------------------------
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var card = raycast_check_for_card()
			if card:
				start_drag(card)
		else:
			if card_being_dragged:
				finish_drag()

func start_drag(card):
	print("Start drag")
	card_being_dragged = card
	card_being_dragged.scale = Vector2(1.1, 1.1)
	card_being_dragged.z_index = 2

func finish_drag():
	print(card_being_dragged.card_stats.is_players)
	if raycast_check_for_card() and card_being_dragged.card_stats.is_players:
		upgrade_card(card_being_dragged, raycast_check_for_upgrade_card())
		print("Upgrade card start")
		
		var temp = []
		for i in inventory:
			print("card stats are " + str(i.card_stats.upgrade_level))
			temp.push_back(i.card_stats)
			Global.player_inventory = temp
		card_being_dragged.scale = Vector2(1, 1)
		card_being_dragged.z_index = 1
		card_being_dragged = null
		return
	
	card_being_dragged.scale = Vector2(1, 1)
	card_being_dragged.z_index = 1
	add_card_to_hand(card_being_dragged)
	card_being_dragged = null

func upgrade_card(upgrade_card, base_card):
	if  upgrade_card.position != base_card.position and upgrade_card.card_stats.upgrade_level == base_card.card_stats.upgrade_level:
		if base_card.card_stats.upgrade_level >= 4:
			add_card_to_hand(upgrade_card)
			return
		remove_card_from_hand(upgrade_card)
		upgrade_card.queue_free()
		base_card.upgrade_card(base_card.card_stats.upgrade_level + 1)
		base_card.update_card_ui()
		print("Upgrade card end")
	else:
		add_card_to_hand(upgrade_card)
	pass

func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null 

func raycast_check_for_upgrade_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return get_card_with_lowest_z_index(result)
	return null 


func inventory_collision_toggle():
	for i in get_children():
			if !i.is_in_group("card"): continue
			if i.disabled_collision:
				i.enable_collision()
			else:
				i.disable_collision()
				

func get_card_with_lowest_z_index(cards):
	var lowest_z_card = cards[0].collider.get_parent()
	var lowest_z_index = lowest_z_card.z_index
	
	for i in range(1, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index < lowest_z_index:
			lowest_z_card = current_card
			lowest_z_index = current_card.z_index
	return lowest_z_card
