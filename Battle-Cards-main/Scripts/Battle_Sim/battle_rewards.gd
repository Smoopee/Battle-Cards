extends Node2D

@onready var xp_reward_label = %XpRewardUnit
@onready var gold_reward_label = %GoldRewardUnit
@onready var player_gold_label = %GoldUnit
@onready var player_xp_label = %XpUnit

var center_screen_x
var level_up_screen = false

func _ready():
	center_screen_x = get_viewport().size.x / 2
	Global.connect("level_up", level_up)
	$BGForRewardBox.position.x = center_screen_x - $BGForRewardBox.size.x / 2
	
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
	get_tree().get_first_node_in_group("bottom ui").toggle_inventory(true)
	var new_scene = load(enemy_reward.card_scene_path).instantiate()
	new_scene.card_stats = enemy_reward
	add_child(new_scene)
	new_scene.card_stats.in_enemy_deck = false
	new_scene.card_stats.is_players = false
	new_scene.card_stats.cd_remaining = 0
	new_scene.card_stats.on_cd = false
	new_scene.get_node("BaseCard").get_node("Area2D").collision_mask = 1
	new_scene.get_node("BaseCard").get_node("Area2D").collision_layer = 1
	new_scene.upgrade_card(new_scene.card_stats.upgrade_level)
	new_scene.item_enchant(new_scene.card_stats.item_enchant)
	new_scene.position = Vector2(center_screen_x, 350)
	new_scene.z_index = 3


func skill_reward(enemy_reward):
	get_tree().get_first_node_in_group("bottom ui").toggle_character(true)
	var new_scene = load(enemy_reward.skill_scene_path).instantiate()
	enemy_reward = player_skill_upgrade_match(enemy_reward)
	new_scene.skill_stats = enemy_reward
	add_child(new_scene)
	new_scene.get_node("BaseSkill").get_node("Area2D").collision_mask = 512
	new_scene.get_node("BaseSkill").get_node("Area2D").collision_layer = 512
	new_scene.upgrade_skill(new_scene.skill_stats.upgrade_level)
	new_scene.position = Vector2(center_screen_x, 350)
	new_scene.z_index = 3

func player_skill_upgrade_match(skill):
	var player_skills = []
	for j in Global.player_skills:
		player_skills.push_back(j.name)
	
	if player_skills.find(skill.name) > -1:
		skill.upgrade_level = Global.player_skills[player_skills.find(skill.name)].upgrade_level
		return skill
	
	return skill

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

	if level_up_screen == true:
		Global.battle_tracker += 1
		Global.current_scene = "level up selection"
		await get_tree().get_first_node_in_group("main").scene_transition(1, 1.0)
		get_tree().get_first_node_in_group("main").add_scene("res://Scenes/UI/LevelUpSelection/level_up_selection.tscn")
		get_parent().queue_free()
	else:
		Global.current_scene = "intermission"
		Global.battle_tracker += 1
		await get_tree().get_first_node_in_group("main").scene_transition(1, 1.0)
		get_tree().get_first_node_in_group("main").add_scene("res://Scenes/UI/Intermission/intermission.tscn")
		get_parent().queue_free()
		
