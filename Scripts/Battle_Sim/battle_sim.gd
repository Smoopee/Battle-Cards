extends Node2D

@onready var player_deck = $player_deck
@onready var enemy_node = $Enemy
@onready var player_inventory = $player_inventory
@onready var player_skills = $PlayerSkills
@onready var ui = $UI
@onready var player_node = $Player

var rng = RandomNumberGenerator.new()

var player_inventory_list
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
		
		player_node.get_node("Berserker").change_rage(-3)
		
		ui.combat_log_break()
		await get_tree().create_timer(.5).timeout
		
		player_deck.discard(player_card)
		enemy_node.discard(enemy_card)
		
		if death_checker(): break
		
	if death_checker(): return
	turn_counter += turn_incrementer
	store_active_decks()
	next_turn_handler()
	

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
		Global.enemy_active_deck = []
		for i in $player_deck.get_children():
			if i.is_in_group("card"): i.queue_free()
		for i in enemy_node.get_children():
			if i.is_in_group("card"): i.queue_free()
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
	var damage = i.card_stats.dmg + player.player_stats.attack
	if crit_check(i): 
		damage *= 2
		crit = true
	
	if i.card_stats.in_enemy_deck: 
		change_health(false, damage)
		ui.update_combat_log_damage_taken(damage, player, enemy, true, i, crit)
		ui.change_enemy_damage_number(damage, crit)
		
	else:
		change_health(true, damage)
		ui.update_combat_log_damage_taken(damage, player, enemy, false, i, crit)
		ui.change_player_damage_number(damage, crit)

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
		player_node.get_node("Berserker").change_rage(value)
		enemy.enemy_stats.health -= value
		enemy_node.change_enemy_health()
	else:
		Global.change_player_health(-value)
		player_node.get_node("Berserker").change_rage(value)
		player.player_stats.health -= value
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
	
	player_deck_list = build_player_deck_list()
	player_inventory_list = build_player_inventory_list()
	enemy_deck_list = build_enemy_deck_list() 
	
	
	player_skill_list = player_skills.add_skills()
	enemy_skill_list = enemy_node.add_skills()
	on_start_skill()
	combat(player_deck_list, enemy_deck_list)
	$Button.visible = false

func build_player_deck_list():
	return player_deck.build_deck()
func build_enemy_deck_list():
	return enemy_node.build_deck() 
func build_player_inventory_list():
	return player_inventory.build_inventory()

func _on_continue_button_button_down():
	for i in $NextTurn/DeckBuilder/EnemyCards.get_children():
		i.queue_free()
	recall_active_decks()
	
	for i in $Enemy.get_children():
		i.visible = true
	
	$HBoxContainer.visible = false
	$NextTurn.visible = false
	
	player_deck_list = build_player_deck_list()
	enemy_deck_list = build_enemy_deck_list() 
	player_inventory_list = build_player_inventory_list()
	
	combat(player_deck_list, enemy_deck_list)

func store_active_decks():
	var blank = load("res://Resources/Cards/blank.tres")
	
	var temp_inventory = []
	for i in player_inventory_list:
		if i != null:
			temp_inventory.push_back(i.card_stats)
		else: 
			temp_inventory.push_back(null)
	Global.player_active_inventory = temp_inventory

	var temp_deck = []
	for i in player_deck_list:
		if i.card_stats.is_blank == false:
			temp_deck.push_back(i.card_stats)
		else:
			temp_deck.push_back(null)
	Global.player_active_deck = temp_deck

	var temp_enemy_deck = []
	for i in enemy_deck_list:
		if i != blank:
			temp_enemy_deck.push_back(i.card_stats)
		else:
			temp_enemy_deck.push_back(null)
	Global.enemy_active_deck = temp_enemy_deck

func next_turn_handler():
	$NextTurn.next_turn()

	
	$NextTurn.visible = true
	$HBoxContainer.visible = true
	for i in $player_deck.get_children():
		i.visible = false
		if i.is_in_group("card"): i.queue_free()
	for i in enemy_node.get_children():
		if i.is_in_group("card"): i.queue_free()

	enemy_node.create_enemy_cards()

func recall_active_decks():
	var blank = load("res://Resources/Cards/blank.tres")
	
	var temp_inventory = []
	for i in $NextTurn/DeckBuilder/CardManager.inventory_card_slot_reference:
		if i != null:
			
			temp_inventory.push_back(i.card_stats.duplicate())
		else:
			temp_inventory.push_back(null)
	Global.player_active_inventory = temp_inventory

	var temp_deck = []
	
	for i in $NextTurn/DeckBuilder/CardManager.deck_card_slot_reference:
		if i != null:
			print("stats " + str(i.card_stats.dmg))
			temp_deck.push_back(i.card_stats.duplicate())
		else:
			temp_deck.push_back(blank)
	Global.player_active_deck = temp_deck


