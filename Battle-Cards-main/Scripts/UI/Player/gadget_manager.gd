extends Node2D

const COLLISION_MASK_GADGET = 4194304
const COLLISION_MASK_MERCHANT_GADGET = 8388608
const COLLISION_MASK_PLAYER = 8

var screen_size

var gadget_previous_position
var gadget_being_dragged

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	if gadget_being_dragged:
		var mouse_pos = get_global_mouse_position()
		gadget_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), 
			clamp(mouse_pos.y, 0, screen_size.y))

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var merchant_gadget = raycast_check_for_gadget()
			if merchant_gadget:
				start_drag_gadget(merchant_gadget)
		else:
			if gadget_being_dragged:
				finish_drag_gadget()

func finish_drag_gadget():
	$"../MerchantGadgets".animate_gadget_to_position(gadget_being_dragged, gadget_previous_position)
	if raycast_check_for_player(): 
		var upgradeable_gadget = check_for_upgrade_gadget()
		if upgradeable_gadget:
			upgrade_gadget(upgradeable_gadget)
		else:
			buy_gadget()
	gadget_reset()

func start_drag_gadget(gadget):
	gadget_being_dragged = gadget.get_parent()
	gadget_being_dragged.scale = Vector2(1.1, 1.1) * Global.ui_scaler
	gadget_being_dragged.z_index = 2
	gadget_previous_position = gadget.get_parent().position

func raycast_check_for_gadget():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_MERCHANT_GADGET
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

func gadget_reset():
	gadget_being_dragged.scale = Vector2(1, 1) * Global.ui_scaler
	gadget_being_dragged.z_index = 1
	gadget_being_dragged = null

func check_for_upgrade_gadget():
	if gadget_being_dragged.gadget_stats.upgrade_level >= 4: return
	for i in get_tree().get_first_node_in_group("player gadgets").get_children():
		if i.gadget_stats.name != gadget_being_dragged.gadget_stats.name:
			continue
		if i.gadget_stats.upgrade_level == gadget_being_dragged.gadget_stats.upgrade_level:
			return i
	return false

func upgrade_gadget(gadget_being_upgraded):
	if Global.player_gold < gadget_being_dragged.gadget_stats.buy_price:
		print("not enough gold")
		return
	$"../MerchantGadgets".remove_gadget_from_inventory(gadget_being_dragged)
	gadget_being_dragged.queue_free()
	gadget_being_upgraded.upgrade_gadget(gadget_being_upgraded.gadget_stats.upgrade_level + 1)

func buy_gadget():
	if Global.player_gold < gadget_being_dragged.gadget_stats.buy_price:
		print("not enough gold")
		return
	Global.player_gold -= gadget_being_dragged.gadget_stats.buy_price
	Global.player_gadgets.push_back(gadget_being_dragged.gadget_stats)
	get_tree().get_first_node_in_group("player gadgets").add_gadget(gadget_being_dragged.gadget_stats)
	$"../MerchantGadgets".remove_gadget_from_inventory(gadget_being_dragged)
	gadget_being_dragged.queue_free()
	update_player_gold()
