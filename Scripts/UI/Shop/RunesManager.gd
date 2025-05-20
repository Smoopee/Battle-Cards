extends Node2D


const COLLISION_MASK_MERCHANT_RUNES = 65536 
const COLLISION_MASK_PLAYER = 8

var screen_size

var rune_previous_position
var rune_being_dragged

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	if rune_being_dragged:
		var mouse_pos = get_global_mouse_position()
		rune_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), 
			clamp(mouse_pos.y, 0, screen_size.y))

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var merchant_rune = raycast_check_for_merchant_rune()
			if merchant_rune:
				start_drag_rune(merchant_rune)
		else:
			if rune_being_dragged:
				finish_drag_rune()

func start_drag_rune(rune):
	rune_being_dragged = rune.get_parent()
	rune_being_dragged.scale = Vector2(1.1, 1.1)
	rune_being_dragged.z_index = 2
	rune_previous_position = rune.get_parent().position

func finish_drag_rune():
	$"../MerchantRunes".animate_rune_to_position(rune_being_dragged, rune_previous_position)
	if raycast_check_for_player(): 
		buy_rune()
	rune_reset()

func raycast_check_for_merchant_rune():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_MERCHANT_RUNES
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
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

func update_player_gold():
	get_tree().get_first_node_in_group("bottom ui").change_player_gold() 

func buy_rune():
	if Global.player_gold < rune_being_dragged.rune_stats.buy_price:
		print("not enough gold")
		return
	Global.player_gold -= rune_being_dragged.rune_stats.buy_price
	get_tree().get_first_node_in_group("player runes").add_rune(rune_being_dragged.rune_stats)
	$"../MerchantRunes".remove_rune_from_inventory(rune_being_dragged)
	rune_being_dragged.queue_free()
	update_player_gold()

func rune_reset():
	rune_being_dragged.scale = Vector2(1, 1)
	rune_being_dragged.z_index = 1
	rune_being_dragged = null
