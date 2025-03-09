extends Node2D

@onready var player_deck = $player_deck
@onready var enemy_node = $Enemy
@onready var player_skills = $PlayerSkills
@onready var ui = $UI
@onready var player_node = $Player

var rng = RandomNumberGenerator.new()

var player_deck_list 
var enemy_deck_list
var player_skill_list = []
var enemy_skill_list = []
var player_armor = 0
var enemy_armor = 0
var turn_counter = 1

var player_bleed_dmg = 0
var enemy_bleed_dmg = 0
var enemy
var player


func combat(player_deck_list, enemy_deck_list):
	enemy =  get_tree().get_nodes_in_group("enemy")[0] 
	player =  get_tree().get_nodes_in_group("character")[0] 

	var turn_incrementer = 1

	print("It is turn " + str(turn_counter))
	buff_keeper()
	player_deck.build_deck_position()
	enemy_node.build_deck_position()
	
	for i in range(0, 10):
		var player_card = player_deck_list[i]
		var enemy_card = enemy_deck_list[i]
		
		player_deck.play_card(player_card)
		enemy_node.play_card(enemy_card)
		
		player_card.get_node("AnimationPlayer").play("attack_animation")
		enemy_card.get_node("AnimationPlayer").play("enemy_attack_animation")
		
		
		var player_effect = player_card.effect(player_deck_list, enemy_deck_list, player, enemy)
		var enemy_effect = enemy_card.effect(player_deck_list, enemy_deck_list, player, enemy)
		ui.update_combat_log_effect(player_effect)
		
		damage_func(player_card)
		damage_func(enemy_card)
		
		bleed_func(player_card)
		bleed_func(enemy_card)
		
		heal_func(player_card)
		heal_func(enemy_card)
		
		bleed_damage_keeper()
		
		ui.combat_log_break()
		await get_tree().create_timer(1.5).timeout
		
		player_deck.discard(player_card)
		enemy_node.discard(enemy_card)
		
		if death_checker(): break
		
		if i == 9:
			turn_counter += turn_incrementer
			$HBoxContainer.visible = true

func on_start_skill():
	for i in player_skill_list:
		i.effect()
	
	for i in enemy_skill_list:
		i.effect()

func death_checker():
	if Global.player_health <= 0: 
		print("You have Died!")
		return true
	else: false
	
	if Global.enemy_health <= 0: 
		Global.player_gold += Global.current_enemy.gold
		Global.player_xp += Global.current_enemy.xp
		$BattleRewards.update_rewards()
		$BattleRewards.visible = true
		return true
		
	else: false

func crit_check(i):
	var critical_strike_check = rng.randf_range(0, 1)
	
	if critical_strike_check <= i.card_stats.critical_strike_chance:
		return true
	else: return false

func damage_func(i):
	if i.card_stats.dmg <= 0: return
	var crit = false
	var damage = i.card_stats.dmg
	if crit_check(i): 
		damage *= 2
		crit = true
	
	if i.card_stats.in_enemy_deck: 
		change_health(false, damage)
		ui.update_combat_log_damage_taken(damage, player, enemy, true, i, crit)
	else:
		change_health(true, damage)
		ui.update_combat_log_damage_taken(damage, player, enemy, false, i, crit)
		
func bleed_func(i):
	if i.card_stats.bleed_dmg <= 0: return
	
	if i.card_stats.in_enemy_deck: 
		player.player_stats.bleeding_dmg += i.card_stats.bleed_dmg
		ui.update_combat_log_bleed("bleed_func", player.player_stats.bleeding_dmg, player, enemy, true, null, null)
	else: 
		enemy.enemy_stats.bleeding_dmg += i.card_stats.bleed_dmg
		ui.update_combat_log_bleed("bleed_func", enemy.enemy_stats.bleeding_dmg, player, enemy, false, null, null)
		
func bleed_damage_keeper():
	if player.player_stats.bleeding_dmg > 0:
		change_health(false, player.player_stats.bleeding_dmg)
		ui.update_combat_log_bleed("bleed_damage_keeper", player.player_stats.bleeding_dmg, player, enemy, true, null, null)
	if player.player_stats.bleeding_dmg> 0: player.player_stats.bleeding_dmg-= 1
	
	if enemy.enemy_stats.bleeding_dmg > 0:
		change_health(true, enemy.enemy_stats.bleeding_dmg)
		ui.update_combat_log_bleed("bleed_damage_keeper", enemy.enemy_stats.bleeding_dmg, player, enemy, false, null, null)
	if enemy.enemy_stats.bleeding_dmg> 0: enemy.enemy_stats.bleeding_dmg-= 1

func change_health(character, value):
	if character:
		Global.change_enemy_health(-value)
		enemy.enemy_stats.health -= value
		ui.change_player_damage_number(value)
		enemy_node.change_enemy_health()
	else:
		Global.change_player_health(-value)
		player.player_stats.health -= value
		ui.change_enemy_damage_number(value)
		player_node.change_player_health()

func heal_func(i):
	if i.card_stats.heal <= 0: return
	var player_card = true
	if i.card_stats.in_enemy_deck: player_card = false
	
	var heal = i.card_stats.heal
	
	if crit_check(i): heal *= 2
	change_health(!player_card, -heal)

func buff_keeper():
	var buffs = get_tree().get_nodes_in_group("buff")
	for i in buffs:
		i.remove_counter()

func _on_button_button_down():
	
	player_deck_list = player_deck.build_deck()

	enemy_deck_list = enemy_node.build_deck() 
	
	
	player_skill_list = player_skills.add_skills()
	enemy_skill_list = enemy_node.add_skills()
	on_start_skill()
	combat(player_deck_list, enemy_deck_list)
	$Button.visible = false

func _on_continue_button_button_down():
	$HBoxContainer.visible = false
	combat(player_deck_list, enemy_deck_list)

func _on_rearrange_button_button_down():
	get_tree().change_scene_to_file(("res://Scenes/UI/deck_builder.tscn"))


func _on_inventory_button_button_down():
	if !$PlayerInventory.visible:
		$PlayerInventory.visible = true
	else:
		$PlayerInventory.visible = false
	
	if !$ColorRect.visible:
		$ColorRect.visible = true
	else:
		$ColorRect.visible = false
		
	
