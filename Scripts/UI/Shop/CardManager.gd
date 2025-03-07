extends Node2D

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_MERCHANT_CARD = 64
const COLLISION_MASK_MERCHANT = 32
const COLLISION_MASK_PLAYER = 8


var screen_size
var card_being_dragged
var merchant_inventory_reference
var player_inventory_reference


func _ready():
	screen_size = get_viewport_rect().size
	merchant_inventory_reference = $"../MerchantCards"
	player_inventory_reference = $"../Inventory"
	
	update_player_gold()
	
	for i in get_children():
		if !i.card_stats.is_players:
			print("Merchant Inventory")

func _process(delta):
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), 
			clamp(mouse_pos.y, 0, screen_size.y))

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var merchant_card = raycast_check_for_merchant_card()
			var player_card = raycast_check_for_card()
			if merchant_card:
				start_drag(merchant_card)
			if player_card:
				start_drag(player_card)
		else:
			if card_being_dragged:
				finish_drag()

func start_drag(card):
	card_being_dragged = card
	card_being_dragged.scale = Vector2(1.1, 1.1)
	card_being_dragged.z_index = 2

func finish_drag():
	if raycast_check_for_card() and card_being_dragged.card_stats.is_enchantment:
		enchant_from_merchant(card_being_dragged, raycast_check_for_card())
		print("Enchant card")
		card_being_dragged = null
		return
	
	if raycast_check_for_player() and not card_being_dragged.card_stats.is_players:
		buy_card(card_being_dragged)
		print("Buy card")
		card_being_dragged = null
		return
	
	if raycast_check_for_merchant() and card_being_dragged.card_stats.is_players:
		sell_card(card_being_dragged)
		card_being_dragged = null
		return
	
	if raycast_check_for_card() and card_being_dragged.card_stats.is_players:
		upgrade_card(card_being_dragged, raycast_check_for_upgrade_card())
		print("Upgrade card")
		card_being_dragged = null
		return
	
	if raycast_check_for_card() and not card_being_dragged.card_stats.is_players:
		upgrade_from_merchant(card_being_dragged, raycast_check_for_upgrade_card())
		print("Upgrade from merchant")
		card_being_dragged = null
		return
	
		
	if !card_being_dragged.card_stats.is_players:
		$"../MerchantCards".add_card_to_hand(card_being_dragged)
		
	if card_being_dragged.card_stats.is_players:
		$"../Inventory".add_card_to_hand(card_being_dragged)
	
	card_being_dragged = null

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

func raycast_check_for_merchant_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_MERCHANT_CARD
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
		return result[0]
	return null 

func raycast_check_for_player():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_PLAYER
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0]
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

func get_card_with_lowest_z_index(cards):
	var lowest_z_card = cards[0].collider.get_parent()
	var lowest_z_index = lowest_z_card.z_index
	
	for i in range(1, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index < lowest_z_index:
			lowest_z_card = current_card
			lowest_z_index = current_card.z_index
	return lowest_z_card

func sell_card(card):
	Global.player_gold += card.card_stats.sell_price
	merchant_inventory_reference.add_card_to_hand(card)
	player_inventory_reference.remove_card_from_hand(card)
	card.get_node("Area2D").collision_layer = 2
	card.get_node("Area2D").collision_mask = 2
	card.card_stats.is_players = false
	card.card_shop_ui()
	update_player_gold()

func buy_card(card):
	if player_inventory_reference.inventory.size() >= 15:
		merchant_inventory_reference.add_card_to_hand(card)
		print("Not enough space")
		return
	if Global.player_gold < card.card_stats.buy_price:
		merchant_inventory_reference.add_card_to_hand(card)
		print("Not enough gold")
		return
	Global.player_gold -= card.card_stats.buy_price
	player_inventory_reference.add_card_to_hand(card)
	merchant_inventory_reference.remove_card_from_hand(card)
	card.get_node("Area2D").collision_layer = 1
	card.get_node("Area2D").collision_mask = 1
	card.card_stats.is_players = true
	card.card_shop_ui()
	update_player_gold()

func upgrade_card(upgrade_card, base_card):
	if  upgrade_card.position != base_card.position and upgrade_card.card_stats.upgrade_level == base_card.card_stats.upgrade_level:
		if base_card.card_stats.upgrade_level >= 4:
			player_inventory_reference.add_card_to_hand(upgrade_card)
			return
		player_inventory_reference.remove_card_from_hand(upgrade_card)
		upgrade_card.queue_free()
		base_card.upgrade_card(base_card.card_stats.upgrade_level + 1)
		base_card.update_card_ui()
		base_card.card_shop_ui()
	else:
		player_inventory_reference.add_card_to_hand(upgrade_card)
	pass

func upgrade_from_merchant(upgrade_card, base_card):
	if  upgrade_card.position != base_card.position and upgrade_card.card_stats.upgrade_level == base_card.card_stats.upgrade_level:
		if Global.player_gold < upgrade_card.card_stats.buy_price:
			merchant_inventory_reference.add_card_to_hand(upgrade_card)
			print("Not enough gold")
			return
		if base_card.card_stats.card_scene_path != upgrade_card.card_stats.card_scene_path:
			merchant_inventory_reference.add_card_to_hand(upgrade_card)
			return
		if base_card.card_stats.upgrade_level >= 4:
			merchant_inventory_reference.add_card_to_hand(upgrade_card)
			return
		Global.player_gold -= base_card.card_stats.buy_price
		merchant_inventory_reference.remove_card_from_hand(upgrade_card)
		upgrade_card.queue_free()
		base_card.upgrade_card(base_card.card_stats.upgrade_level + 1)
		base_card.update_card_ui()
		base_card.card_shop_ui()
		update_player_gold()
	else:
		merchant_inventory_reference.add_card_to_hand(upgrade_card)
	pass

func enchant_from_merchant(enchant_card, base_card):
	if Global.player_gold < enchant_card.card_stats.buy_price:
			merchant_inventory_reference.add_card_to_hand(enchant_card)
			print("Not enough gold")
			return
	Global.player_gold -= enchant_card.card_stats.buy_price
	merchant_inventory_reference.remove_card_from_hand(enchant_card)
	var temp = load(base_card.card_stats.card_scene_path).instantiate()
	enchant_card.queue_free()
	base_card.add_child(temp)
	temp.item_enchant(enchant_card.card_stats.enchanting_with)
	base_card.update_card_ui()
	base_card.card_shop_ui()
	update_player_gold()

func update_player_gold():
	$"../ShopUI/PlayerGold".text = str(Global.player_gold) + " gold"
