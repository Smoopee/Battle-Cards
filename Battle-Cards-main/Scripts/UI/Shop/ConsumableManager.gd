extends Node2D


const COLLISION_MASK_MERCHANT_CONSUMABLE = 8192
const COLLISION_MASK_PLAYER = 8

var screen_size

var consumable_previous_position
var consumable_being_dragged

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	if consumable_being_dragged:
		var mouse_pos = get_global_mouse_position()
		consumable_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), 
			clamp(mouse_pos.y, 0, screen_size.y))

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var merchant_consumable = raycast_check_for_merchant_consumable()
			if merchant_consumable:
				start_drag_consumable(merchant_consumable)
		else:
			if consumable_being_dragged:
				finish_drag_consumable()

func start_drag_consumable(consumable):
	consumable_being_dragged = consumable.get_parent()
	consumable_being_dragged.scale = Vector2(1.1, 1.1) * Global.ui_scaler
	consumable_being_dragged.z_index = 2
	consumable_previous_position = consumable.get_parent().position

func finish_drag_consumable():
	$"../MerchantConsumables".animate_consumable_to_position(consumable_being_dragged, consumable_previous_position)
	if raycast_check_for_player():
		buy_consumable()
	consumable_reset()

func raycast_check_for_merchant_consumable():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_MERCHANT_CONSUMABLE
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
	$"../BottomNavBar".change_player_gold() 

func buy_consumable():
	if Global.player_gold < consumable_being_dragged.consumable_stats.buy_price:
		print("not enough gold")
		return
	Global.player_gold -= consumable_being_dragged.consumable_stats.buy_price
	get_tree().get_first_node_in_group("player consumables").add_consumable(consumable_being_dragged.consumable_stats)
	$"../MerchantConsumables".remove_consumable_from_inventory(consumable_being_dragged)
	consumable_being_dragged.queue_free()
	update_player_gold()

func consumable_reset():
	consumable_being_dragged.scale = Vector2(1, 1) * Global.ui_scaler
	consumable_being_dragged.z_index = 1
	consumable_being_dragged = null
