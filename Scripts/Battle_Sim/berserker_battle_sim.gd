extends Node2D

#Proof of concept=================================================================================
signal physical_damage
signal bleed_damage
signal end_of_turn
signal end_of_round
signal start_of_battle
#===================================================================================================
var current_screen = ""

@onready var player_deck = $player_deck
@onready var enemy_node = $Enemy
@onready var player_inventory = $player_inventory
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
var round_counter = 1

var player_bleed_dmg = 0
var enemy_bleed_dmg = 0
var enemy
var player

var damage

func _ready():
	connect_signal_setup()
	get_node("Timer").wait_time *= Global.COMBAT_SPEED

func connect_signal_setup():
	enemy =  get_tree().get_nodes_in_group("enemy")[0] 
	player =  get_tree().get_nodes_in_group("character")[0]
	
	player.connect_signals(self)

func combat(player_deck_list, enemy_deck_list):
	var is_dead
	var round_incrementer = 1

	print("It is turn " + str(round_counter))
	player_deck.build_deck_position()
	enemy_node.build_deck_position()
	
	for i in player_deck_list:
		i.disable_collision()
	for i in enemy_deck_list:
		i.disable_collision()
	
	for i in range(0, 10):
		var player_card = player_deck_list[i]
		var enemy_card = enemy_deck_list[i]
		
		player_deck.play_card(player_card)
		enemy_node.play_card(enemy_card)
		
		await get_tree().create_timer(.6 * Global.COMBAT_SPEED).timeout
		
		if !player_card.card_stats.on_cd: 
			player_card.attack_animation(player)
			player_card.effect(player_deck_list, enemy_deck_list, player, enemy)
			cooldown_keeper(player_card)
			
		if !enemy_card.card_stats.on_cd:
			enemy_card.attack_animation(enemy)
			enemy_card.effect(player_deck_list, enemy_deck_list, player, enemy)
			cooldown_keeper(enemy_card)
		
		await get_tree().create_timer(.6 * Global.COMBAT_SPEED).timeout
		
		bleed_damage_keeper()
		
		get_node("Timer").start()
		await $Timer.timeout
		player_deck.discard(player_card)
		enemy_node.discard(enemy_card)
		
		get_node("Timer").start()
		await $Timer.timeout
		
		is_dead = death_checker()
		if is_dead: break
		emit_signal("end_of_turn")
	
	if is_dead: return
	round_counter += round_incrementer
	emit_signal("end_of_round")
	next_turn_handler()

func on_start():
	emit_signal("start_of_battle")

func death_checker():
	if Global.player_health <= 0: 
		print("You have Died!")
		return true
	else: false
	
	if Global.enemy_health <= 0: 
		end_fight_cleanup()
		return true
	else: false

func crit_check(i):
	var critical_strike_check = rng.randf_range(0, 1)
	
	if critical_strike_check <= i.card_stats.critical_strike_chance:
		return true
	else: return false

func damage_func(i):
	var crit = false
	if i.card_stats.in_enemy_deck: 
		damage = i.card_stats.dmg + enemy.enemy_stats.attack - player.player_stats.defense
		damage -= player.player_stats.armor
		
	else:  
		damage = i.card_stats.dmg + player.player_stats.attack - enemy.enemy_stats.defense
		damage -= enemy.enemy_stats.armor

	
	if crit_check(i): 
		damage *= 2
		crit = true
	
	if i.card_stats.in_enemy_deck: 
		emit_signal("physical_damage", i, enemy, damage)
		change_health(false, damage)
		ui.change_enemy_damage_number(damage, crit)
		
	else:
		emit_signal("physical_damage", i, player, damage)
		change_health(true, damage)
		ui.change_player_damage_number(damage, crit)

func more_damage(source, target, damage):
	if source == enemy:
		damage = damage - player.player_stats.defense - player.player_stats.armor
		emit_signal("physical_damage", source, enemy, damage)
		change_health(false, damage)
		ui.change_enemy_damage_number(damage, null)
	else:
		damage = damage - enemy.enemy_stats.defense - enemy.enemy_stats.armor
		emit_signal("physical_damage", source, player, damage)
		change_health(true, damage)
		ui.change_player_damage_number(damage, null)

func reflect_damage(target, amount):
	print("In reflect damage")
	if target == enemy:
		change_health(true, amount)
		ui.change_player_reflect_number(amount)
	else:
		change_health(false, amount)
		ui.change_enemy_reflect_number(amount)

func true_damage(target, amount):
	if target == get_tree().get_first_node_in_group("character"): target = false
	else: target = true
	change_health(target, amount)

func bleed_func(i):
	if i.card_stats.bleed_dmg <= 0: return
	
	if i.card_stats.in_enemy_deck: 
		player.player_stats.bleeding_dmg += i.card_stats.bleed_dmg
		print("Player is bleeding")
	else: 
		enemy.enemy_stats.bleeding_dmg += i.card_stats.bleed_dmg
		print("Enemy is bleeding")

func add_bleed_damage(target, amount):
	if target == enemy:
		enemy.enemy_stats.bleeding_dmg += amount
	
	if target == player:
		player.player_stats.bleeding_dmg += amount

func bleed_damage_keeper():
	if player.player_stats.bleeding_dmg > 0:
		emit_signal("bleed_damage", player, player.player_stats.bleeding_dmg)
		ui.change_player_bleed_taken(player.player_stats.bleeding_dmg)
		change_health(false, player.player_stats.bleeding_dmg)
	if player.player_stats.bleeding_dmg> 0: player.player_stats.bleeding_dmg-= 1
	
	if enemy.enemy_stats.bleeding_dmg > 0:
		emit_signal("bleed_damage", enemy, enemy.enemy_stats.bleeding_dmg)
		ui.change_enemy_bleed_taken(enemy.enemy_stats.bleeding_dmg)
		change_health(true, enemy.enemy_stats.bleeding_dmg)
	if enemy.enemy_stats.bleeding_dmg> 0: enemy.enemy_stats.bleeding_dmg-= 1

func change_health(character, value):
	#If character is true, Enemy Loses Health
	if character:
		Global.change_enemy_health(-value)
		enemy.enemy_stats.health -= value
		enemy_node.change_enemy_health()
	else:
		Global.change_player_health(-value)
		player.player_stats.health -= value
		player.change_player_health()

func heal_func(i):
	if i.card_stats.heal <= 0: return
	var player_card = true
	if i.card_stats.in_enemy_deck: player_card = false
	
	var heal = i.card_stats.heal
	
	if crit_check(i): heal *= 2
	change_health(!player_card, -heal)

func more_healing(target, amount):
	if target == enemy:
		change_health(true, -amount)
		ui.change_enemy_heal_number(amount, false)

	if target == player:
		change_health(false, -amount)
		ui.change_player_heal_number(amount, false)

func cooldown_keeper(card):
	card.card_stats.cd_remaining = card.card_stats.cd + 1
	card.card_stats.on_cd = true

func build_player_deck_list():
	return player_deck.build_deck()
func build_enemy_deck_list():
	return enemy_node.build_deck() 
func build_player_inventory_list():
	return player_inventory.build_inventory()


func next_turn_handler():
	$NextTurn.next_turn()
	$NextTurn.visible = true
	$CanvasLayer/ContinueButton.visible = true
	$CanvasLayer/ColorRect/HBoxContainer/TalentButton.visible = true


func end_fight_cleanup():
	$NextTurn.next_turn()
	$BattleRewards.update_rewards()
	$BattleRewards.visible = true
	
	$NextTurn.visible = true
	Global.enemy_active_deck = []
	for i in $player_deck.get_children():
		i.card_stats.cd_remaining = 0
		i.card_stats.on_cd = false
		i.update_card_ui()
	for i in enemy_node.get_children():
		i.queue_free()
	$UI/Labels.visible = false
	print("end fight cleanup")
	

func _on_start_button_button_down():
	player_deck_list = $player_deck.initial_build_deck()
	player_inventory_list = $player_inventory.initial_build_inventory()
	enemy_deck_list = enemy_node.initial_build_deck()
	
	on_start()
	combat(player_deck_list, enemy_deck_list)
	$CanvasLayer/StartButton.visible = false

func _on_continue_button_button_down():
	$NextTurn.visible = false
	$player_inventory.visible = false
	$CanvasLayer/ContinueButton.visible = false
	get_tree().get_nodes_in_group("character")[0].inventory_screen_toggle(false)
	$ConsumableManger.visible = true
	$ConsumableManger.process_mode = Node.PROCESS_MODE_INHERIT
	
	player_deck_list = build_player_deck_list()
	enemy_deck_list = build_enemy_deck_list() 
	player_inventory_list = build_player_inventory_list()
	
	combat(player_deck_list, enemy_deck_list)

func _on_menu_button_button_down():
	get_tree().paused = true
	get_node("Timer").paused = true
	
	$CanvasLayer/ColorRect/HBoxContainer/TalentButton.visible = false
	$CanvasLayer/ColorRect/HBoxContainer/MenuButton.visible = false
	$CanvasLayer/ColorRect/HBoxContainer/BackButton.visible = true

func _on_back_button_button_down():
	match(current_screen):
		"talents":
			$TalentTree.visible = false

	get_tree().paused = false
	get_node("Timer").paused = false
	
	$CanvasLayer/ColorRect/HBoxContainer/TalentButton.visible = true
	$CanvasLayer/ColorRect/HBoxContainer/MenuButton.visible = true
	$CanvasLayer/ColorRect/HBoxContainer/BackButton.visible = false

func _on_talent_button_button_down():
	get_tree().paused = true
	get_node("Timer").paused = true
	$TalentTree.visible = true
	$CanvasLayer/ColorRect/HBoxContainer/TalentButton.visible = false
	$CanvasLayer/ColorRect/HBoxContainer/MenuButton.visible = false
	$CanvasLayer/ColorRect/HBoxContainer/BackButton.visible = true
	current_screen = "talents"

func _on_timer_timeout():
	pass # Replace with function body.

