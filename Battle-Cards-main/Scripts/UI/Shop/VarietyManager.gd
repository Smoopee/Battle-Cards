extends Node2D


const COLLISION_MASK_MERCHANT_ENCHANTMENTS = 131072 
const COLLISION_MASK_CARD = 1

var screen_size

var enchantment_previous_position
var enchantment_being_dragged

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	if enchantment_being_dragged:
		var mouse_pos = get_global_mouse_position()
		enchantment_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), 
			clamp(mouse_pos.y, 0, screen_size.y))

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var merchant_enchantment = raycast_check_for_merchant_enchantment()
			if merchant_enchantment:
				start_drag_enchantment(merchant_enchantment)
		else:
			if enchantment_being_dragged:
				finish_drag_enchantment()

func start_drag_enchantment(enchantment):
	enchantment_being_dragged = enchantment.get_parent()
	enchantment_being_dragged.scale = Vector2(1.1, 1.1) * Global.ui_scaler
	enchantment_being_dragged.z_index = 2
	enchantment_previous_position = enchantment.get_parent().position

func finish_drag_enchantment():
	$"../MerchantEnchantments".animate_enchantment_to_position(enchantment_being_dragged, enchantment_previous_position)
	if raycast_check_for_card(): 
		enchant_from_merchant(enchantment_being_dragged, raycast_check_for_card())
	enchantment_reset()

func raycast_check_for_merchant_enchantment():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_MERCHANT_ENCHANTMENTS
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null 

func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return get_card_with_highest_z_index(result)
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

func update_player_gold():
	$"../BottomNavBar".change_player_gold() 

func enchant_from_merchant(enchantment, base_card):
	if Global.player_gold < enchantment.enchantment_stats.buy_price:
			$"../MerchantEnchantments".animate_enchantment_to_position(enchantment)
			print("Not enough gold")
			return
	Global.player_gold -= enchantment.enchantment_stats.buy_price
	$"../MerchantEnchantments".remove_enchantment_from_inventory(enchantment)
	enchantment.queue_free()
	base_card.item_enchant(enchantment.enchantment_stats.enchantment_name)
	base_card.update_card_ui()
	base_card.card_shop_ui()
	update_player_gold()

func enchantment_reset():
	enchantment_being_dragged.scale = Vector2(1, 1) * Global.ui_scaler
	enchantment_being_dragged.z_index = 1
	enchantment_being_dragged = null
