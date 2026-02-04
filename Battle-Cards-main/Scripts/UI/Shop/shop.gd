extends Node2D

signal instantiate_merchant

var current_merhant_organizer
var merchant_type 

func _ready():
	get_tree().get_first_node_in_group("character ui").toggle_inventory(false)
	var merchant = get_tree().get_first_node_in_group("merchant")
	emit_signal("instantiate_merchant", merchant)
	if merchant.merchant_stats.merchant_type == "Card":
		merchant_type = "Card"
		$CardManager.process_mode = Node.PROCESS_MODE_INHERIT
		$MerchantCards.create_merchant_inventory()
		current_merhant_organizer = $MerchantCards
		get_tree().get_first_node_in_group("character ui").toggle_inventory(true)
	elif merchant.merchant_stats.merchant_type == "Skill":
		merchant_type = "Skill"
		$SkillManager.process_mode = Node.PROCESS_MODE_INHERIT
		$MerchantSkills.create_merchant_inventory()
		current_merhant_organizer = $MerchantSkills
	elif merchant.merchant_stats.merchant_type == "Gadget":
		merchant_type = "Gadget"
		$GadgetManager.process_mode = Node.PROCESS_MODE_INHERIT
		$MerchantGadgets.create_merchant_inventory()
		current_merhant_organizer = $MerchantGadgets
	elif merchant.merchant_stats.merchant_type == "Consumable":
		merchant_type = "Consumable"
		$MerchantConsumableManager.process_mode = Node.PROCESS_MODE_INHERIT
		$MerchantConsumables.create_merchant_inventory()
		current_merhant_organizer = $MerchantConsumables
		get_tree().get_first_node_in_group("items ui").toggle_consumables(true)
	elif merchant.merchant_stats.merchant_type == "Enchantment":
		merchant_type = "Enchantment"
		$EnchantmentManager.process_mode = Node.PROCESS_MODE_INHERIT
		$MerchantEnchantments.create_merchant_inventory()
		current_merhant_organizer = $MerchantEnchantments
	elif merchant.merchant_stats.merchant_type == "Rune":
		merchant_type = "Rune"
		$RunesManager.process_mode = Node.PROCESS_MODE_INHERIT
		$MerchantRunes.create_merchant_inventory()
		current_merhant_organizer = $MerchantRunes
		
	$ShopUI.position = merchant.position + Vector2(100, 0)
	toggle_refresh(merchant)

func _on_exit_button_button_down():
	inventory_and_deck_save()
	Global.player_consumables = get_tree().get_first_node_in_group("player consumables").get_consumable_array()
	Global.player_runes = get_tree().get_first_node_in_group("player runes").get_rune_array()
	Global.save_function()
	if Global.intermission_tracker <= 1: 
		Global.intermission_tracker += 1
		Global.current_scene = "intermission"
		await get_tree().get_first_node_in_group("main").scene_transition(1, 1.0)
		get_parent().add_scene("res://Scenes/UI/Intermission/intermission.tscn")
		queue_free()
	else:
		Global.intermission_tracker = 0
		Global.current_scene = "enemy_selection"
		await get_tree().get_first_node_in_group("main").scene_transition(1, 1.0)
		get_parent().add_scene("res://Scenes/UI/EnemySelection/enemy_selection.tscn")
		queue_free()

func _on_reroll_button_button_down():
	if Global.player_gold < 5:
		return
	current_merhant_organizer.inventory = []
	
	for i in current_merhant_organizer.get_children():
		if merchant_type == "Card":
			if i.card_stats.is_players: continue
		current_merhant_organizer.remove_child(i)
		i.queue_free()
	
	current_merhant_organizer.inventory_db = []
	current_merhant_organizer.create_merchant_inventory()
	
	Global.player_gold -= 5
	get_tree().get_first_node_in_group("bottom ui").change_player_gold()

func inventory_and_deck_save():
	var deck_and_inventory_reference = get_tree().get_first_node_in_group("player cards")
	var temp_inventory = []
	for i in deck_and_inventory_reference.inventory_card_slot_reference:
		if i != null:
			temp_inventory.push_back(i.card_stats)
		else:
			temp_inventory.push_back(null)
	Global.player_inventory = temp_inventory

	var temp_deck = []
	for i in deck_and_inventory_reference.deck_card_slot_reference:
		if i != null:
			temp_deck.push_back(i.card_stats)
		else:
			temp_deck.push_back(null)
	Global.player_deck = temp_deck

func toggle_refresh(merchant):
	if merchant.merchant_stats.can_refresh == false:
		$ShopUI/RerollButton.visible = false
	else: $ShopUI/RerollButton.visible = true
