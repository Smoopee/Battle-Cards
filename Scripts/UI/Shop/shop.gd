extends Node2D

@onready var merchant_cards = $MerchantCards

var merchant_type 
var is_inventory_toggle = true

func _ready():
	var merchant = get_tree().get_first_node_in_group("merchant")
	if merchant.merchant_type == "Card":
		merchant_type = "Card"
		$CardManager.process_mode = Node.PROCESS_MODE_INHERIT
		toggle_inventory()
		$MerchantCards.create_merchant_inventory()
	elif merchant.merchant_type == "Skill":
		merchant_type = "Skill"
		$SkillManager.process_mode = Node.PROCESS_MODE_INHERIT
		is_inventory_toggle = false
		toggle_inventory()
		$MerchantSkills.create_merchant_inventory()
	elif merchant.merchant_type == "Consumables":
		merchant_type = "Consumables"
		$MerchantConsumableManager.process_mode = Node.PROCESS_MODE_INHERIT
		toggle_inventory()
		$MerchantConsumables.create_merchant_inventory()
	elif merchant.merchant_type == "Other":
		merchant_type = "Other"
		$VarietyManager.process_mode = Node.PROCESS_MODE_INHERIT
		$VarietyManager.create_merchant_inventory()

func _input(event):
	if event.is_action_pressed("Inventory"):
		toggle_inventory()

func _on_exit_button_button_down():
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

func _on_reroll_button_button_down():
	if Global.player_gold < 5:
		print("Not enough gold")
		return
	merchant_cards.inventory = []
	
	for i in merchant_cards.get_children():
		if i.card_stats.is_players == false:
			merchant_cards.remove_child(i)
			i.queue_free()
	
	merchant_cards.inventory_db = []
	merchant_cards.create_merchant_inventory()
	
	Global.player_gold -= 5
	$CanvasLayer/ColorRect/PlayerUI.change_player_gold()

func inventory_and_deck_save():
	var deck_and_inventory_reference = $PlayerInventoryScreen
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

func _on_talent_button_button_down():
	pass

func _on_back_button_button_down():
	pass

func toggle_inventory():
	if is_inventory_toggle == true:
		$PlayerInventoryScreen.visible = true
		$Player/Berserker.inventory_screen_toggle(true)
		is_inventory_toggle = false
		$Player/Berserker.process_mode = Node.PROCESS_MODE_DISABLED
		$PlayerInventoryScreen.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		$PlayerInventoryScreen.visible = false
		$Player/Berserker.inventory_screen_toggle(false)
		is_inventory_toggle = true
		$PlayerInventoryScreen.process_mode = Node.PROCESS_MODE_DISABLED
		$Player/Berserker.process_mode = Node.PROCESS_MODE_INHERIT

