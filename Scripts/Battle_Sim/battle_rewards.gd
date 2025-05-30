extends Node2D

@onready var xp_reward_label = $Panel/HBoxContainer/VariableContainer/XpReward
@onready var gold_reward_label = $Panel/HBoxContainer/VariableContainer/GoldReward
@onready var player_gold_label = $Panel/HBoxContainer/VariableContainer/Gold
@onready var player_xp_label = $Panel/HBoxContainer/VariableContainer/Xp

var center_screen_x
var reward
var level_up_screen = false

func _ready():
	center_screen_x = get_viewport().size.x / 2
	Global.connect("level_up", level_up)

func level_up():
	level_up_screen = true

func update_rewards():
	var enemy_reward = $"../Enemy".enemy_reward()

	
	if enemy_reward.get_script() == load("res://Resources/Cards/cards_master_resource.gd"):
		card_reward(enemy_reward)
	elif enemy_reward.get_script() == load("res://Resources/Skills/skills_master_resource.gd"):
		skill_reward(enemy_reward)
		
	Global.player_gold += Global.current_enemy.gold
	Global.gain_xp(Global.current_enemy.xp)
	
	xp_reward_label.text = str(Global.current_enemy.xp)
	gold_reward_label.text = str(Global.current_enemy.gold)
	
	player_gold_label.text = str(Global.player_gold)
	player_xp_label.text = str(Global.player_xp)


func card_reward(enemy_reward):
	var new_scene = load(enemy_reward.card_scene_path).instantiate()
	new_scene.card_stats = enemy_reward
	add_child(new_scene)
	new_scene.card_stats.in_enemy_deck = true
	new_scene.card_stats.is_players = true
	new_scene.card_stats.cd_remaining = 0
	new_scene.card_stats.on_cd = false
	new_scene.get_node("BaseCard").get_node("Area2D").collision_mask = 1
	new_scene.get_node("BaseCard").get_node("Area2D").collision_layer = 1
	new_scene.upgrade_card(new_scene.card_stats.upgrade_level)
	new_scene.item_enchant(new_scene.card_stats.item_enchant)
	new_scene.position = Vector2(center_screen_x, 350)
	new_scene.z_index = 3
	reward = new_scene

func skill_reward(enemy_reward):
	get_tree().get_first_node_in_group("character").inventory_screen_toggle(false)
	var new_scene = load(enemy_reward.skill_scene_path).instantiate()
	new_scene.skill_stats = enemy_reward
	new_scene.get_node("BaseSkill").get_node("Area2D").collision_mask = 512
	new_scene.get_node("BaseSkill").get_node("Area2D").collision_layer = 512
	new_scene.get_node("BaseSkill").upgrade_skill(new_scene.skill_stats.upgrade_level)
	new_scene.position = Vector2(center_screen_x, 350)
	new_scene.z_index = 3
	add_child(new_scene)
	reward = new_scene

func _on_button_button_down():
	var card_manager = $"../PlayerCards"
	
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
	
	
	Global.player_consumables = get_tree().get_first_node_in_group("player consumables").get_consumable_array()
	Global.save_function()
	
	
	if Global.intermission_tracker >= 2:
		Global.current_scene = "enemy selection"
		Global.intermission_tracker = 0
		get_tree().change_scene_to_file("res://Scenes/UI/EnemySelection/enemy_selection.tscn")
	elif level_up_screen == true:
		Global.battle_tracker += 1
		Global.current_scene = "level up selection"
		get_tree().change_scene_to_file("res://Scenes/UI/LevelUpSelection/level_up_selection.tscn")
	else:
		Global.current_scene = "intermission"
		Global.battle_tracker += 1
		get_tree().change_scene_to_file("res://Scenes/UI/Intermission/intermission.tscn")
