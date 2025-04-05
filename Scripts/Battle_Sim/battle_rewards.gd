extends Node2D

@onready var xp_reward_label = $Panel/HBoxContainer/VariableContainer/XpReward
@onready var gold_reward_label = $Panel/HBoxContainer/VariableContainer/GoldReward
@onready var player_gold_label = $Panel/HBoxContainer/VariableContainer/Gold
@onready var player_xp_label = $Panel/HBoxContainer/VariableContainer/Xp

var center_screen_x
var reward

func _ready():
	center_screen_x = get_viewport().size.x / 2

func update_rewards():
	var enemy_reward = $"../Enemy".enemy_reward()
	$"../NextTurn/DeckBuilder/PlayerDeck".reward_screen = true
	$"../NextTurn/DeckBuilder/PlayerInventory".reward_screen = true
	$"../NextTurn/DeckBuilder/UpgradeButton".visible = true
	
	
	#Gives double reward if enemy_rewards returns "Double Reward"
	if type_string(typeof(enemy_reward)) == "String":
		Global.player_gold += Global.current_enemy.gold * 2
		Global.gain_xp(Global.current_enemy.xp * 2)
		
		xp_reward_label.text = str(Global.current_enemy.xp * 2)
		gold_reward_label.text = str(Global.current_enemy.gold * 2)
		
		player_gold_label.text = str(Global.player_gold)
		player_xp_label.text = str(Global.player_xp)
		return
		
	else:
		Global.player_gold += Global.current_enemy.gold
		Global.gain_xp(Global.current_enemy.xp)
		
		
		xp_reward_label.text = str(Global.current_enemy.xp)
		gold_reward_label.text = str(Global.current_enemy.gold)
		
		player_gold_label.text = str(Global.player_gold)
		player_xp_label.text = str(Global.player_xp)
		
	var new_scene = load(enemy_reward.card_scene_path).instantiate()
	new_scene.card_stats = enemy_reward
	new_scene.card_stats.in_enemy_deck = true
	new_scene.card_stats.is_players = true
	new_scene.card_stats.cd_remaining = 0
	new_scene.card_stats.on_cd = false
	new_scene.get_node("Area2D").collision_mask = 1
	new_scene.get_node("Area2D").collision_layer = 1
	new_scene.upgrade_card(new_scene.card_stats.upgrade_level)
	new_scene.item_enchant(new_scene.card_stats.item_enchant)
	new_scene.position = Vector2(center_screen_x, 350)
	new_scene.z_index = 3
	add_child(new_scene)
	reward = new_scene

func _on_button_button_down():
	var card_manager = $"../NextTurn/DeckBuilder/CardManager"
	
	var temp_inventory = []
	for i in card_manager.inventory_card_slot_reference:
		if i != null:
			i.card_stats.in_enemy_deck = false
			temp_inventory.push_back(i.card_stats)
		else: 
			temp_inventory.push_back(null)
	Global.player_inventory = temp_inventory

	var temp_deck = []
	for i in card_manager.deck_card_slot_reference:
		if i != null:
			i.card_stats.in_enemy_deck = false
			temp_deck.push_back(i.card_stats)
		else:
			temp_deck.push_back(null)
	Global.player_deck = temp_deck
	
	Global.battle_tracker += 1
	Global.player_consumables = $"../Player/Berserker".get_consumable_array()
	Global.save_function()
	Global.current_scene = "intermission"
	get_tree().change_scene_to_file(("res://Scenes/UI/Intermission/intermission.tscn"))
