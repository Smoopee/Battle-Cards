extends Node2D

@onready var xp_reward_label = $TextureRect/HBoxContainer/VariableContainer/XpReward
@onready var gold_reward_label = $TextureRect/HBoxContainer/VariableContainer/GoldReward
@onready var player_gold_label = $TextureRect/HBoxContainer/VariableContainer/Gold
@onready var player_xp_label = $TextureRect/HBoxContainer/VariableContainer/Xp


var center_screen_x

func _ready():
	center_screen_x = get_viewport().size.x / 2
	
func update_rewards():
	var enemy_reward = $"../Enemy".enemy_reward()
	$"../NextTurn/DeckBuilder/PlayerDeck".reward_screen = true
	$"../NextTurn/DeckBuilder/PlayerInventory".reward_screen = true
	

	
	#Gives double reward if enemy_rewards returns "Double Reward"
	if type_string(typeof(enemy_reward)) == "String":
		xp_reward_label.text = str(Global.current_enemy.xp * 2)
		gold_reward_label.text = str(Global.current_enemy.gold * 2)
		
		Global.player_gold += Global.current_enemy.gold * 2
		Global.player_xp += Global.current_enemy.xp * 2
		
		player_gold_label.text = str(Global.player_gold)
		player_xp_label.text = str(Global.player_xp)
		return
	else:
		Global.player_gold += Global.current_enemy.gold
		Global.player_xp += Global.current_enemy.xp
		
		xp_reward_label.text = str(Global.current_enemy.xp)
		gold_reward_label.text = str(Global.current_enemy.gold)
		
		player_gold_label.text = str(Global.player_gold)
		player_xp_label.text = str(Global.player_xp)
		
	
	var new_scene = load(enemy_reward.card_scene_path).instantiate()
	new_scene.card_stats = enemy_reward
	add_child(new_scene)
	
	new_scene.card_stats.is_players = true
	new_scene.position = Vector2(center_screen_x, 350)
	new_scene.z_index = 3

func _on_button_button_down():
	var card_manager = $"../NextTurn/DeckBuilder/CardManager"
	
	var temp_inventory = []
	for i in card_manager.inventory_card_slot_reference:
		if i != null:
			temp_inventory.push_back(i.card_stats)
		else: 
			temp_inventory.push_back(null)
	Global.player_inventory = temp_inventory

	var temp_deck = []
	for i in card_manager.deck_card_slot_reference:
		if i != null:
			temp_deck.push_back(i.card_stats)
		else:
			temp_deck.push_back(null)
	Global.player_deck = temp_deck
	
	get_tree().change_scene_to_file(("res://Scenes/UI/Intermission/intermission.tscn"))
