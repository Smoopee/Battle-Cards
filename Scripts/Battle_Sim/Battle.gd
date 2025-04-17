extends Node2D


signal physical_damage
signal bleed_damage
signal end_of_turn
signal end_of_round
signal start_of_battle
signal start_of_round
signal bleed_applied
signal card_etb
signal end_fight
#===================================================================================================
var current_screen = ""

@onready var player_deck = $"../player_deck"
@onready var enemy_node = $"../Enemy"
@onready var player_inventory = $"../player_inventory"
@onready var ui = $"../UI"
@onready var player_node = $"../Player"
@onready var next_turn = $"../NextTurn"

var rng = RandomNumberGenerator.new()

var player_inventory_list
var player_deck_list 
var enemy_deck_list
var player_skill_list = []
var enemy_skill_list = []
var player_armor = 0
var enemy_armor = 0
var round_counter = 1
var round_limit = 10

var player_bleed_dmg = 0
var enemy_bleed_dmg = 0
var enemy
var player
var player_card
var enemy_card

var damage

func _ready():
	connect_signal_setup()
	$"../Timer".wait_time *= Global.COMBAT_SPEED
	
	player_deck_list = $"../player_deck".initial_build_deck()
	player_inventory_list = $"../player_inventory".initial_build_inventory()
	enemy_deck_list = enemy_node.initial_build_deck()

func connect_signal_setup():
	enemy = get_tree().get_nodes_in_group("enemy")[0] 
	player = get_tree().get_nodes_in_group("character")[0]

	player.connect_signals(self)

func combat(player_deck_list, enemy_deck_list):
	if round_counter > round_limit:
		end_fight_cleanup()
		return
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
		player_card = player_deck_list[i]
		enemy_card = enemy_deck_list[i]
		
		player_deck.play_card(player_card)
		enemy_node.play_card(enemy_card)
		
		await get_tree().create_timer(.6 * Global.COMBAT_SPEED).timeout
		
		play_card()
		
		await get_tree().create_timer(.6 * Global.COMBAT_SPEED).timeout
		
		bleed_damage_keeper(player)
		bleed_damage_keeper(enemy)
		
		$"../Timer".start()
		await $"../Timer".timeout
		player_deck.discard(player_card)
		enemy_node.discard(enemy_card)
		
		$"../Timer".start()
		await $"../Timer".timeout
		
		is_dead = death_checker()
		if is_dead: break
		emit_signal("end_of_turn")
	
	if is_dead: return
	round_counter += round_incrementer
	emit_signal("end_of_round", round_counter)
	next_turn_handler()

func play_card():
	var first = play_order_check(player_card, enemy_card)
	var second
	if first == player_card: second = enemy_card
	else: second = player_card
	
	if first == player_card:
		if !player_card.card_stats.on_cd: 
			damage = 0
			emit_signal("card_etb", player_card)
			player_card.attack_animation(player_card.card_stats.card_owner)
			player_card.effect(player_deck_list, enemy_deck_list, player, enemy)
			cooldown_keeper(player_card)
		
		if !enemy_card.card_stats.on_cd:
			damage = 0
			emit_signal("card_etb", enemy_card)
			enemy_card.attack_animation(enemy_card.card_stats.card_owner)
			enemy_card.effect(player_deck_list, enemy_deck_list, player, enemy)
			cooldown_keeper(enemy_card)
	else:
		if !enemy_card.card_stats.on_cd: 
			damage = 0
			emit_signal("card_etb", enemy_card)
			enemy_card.attack_animation(enemy_card.card_stats.card_owner)
			enemy_card.effect(player_deck_list, enemy_deck_list, player, enemy)
			cooldown_keeper(enemy_card)
		
		if !player_card.card_stats.on_cd:
			print("Player card is " + str(player_card.card_stats.name))
			damage = 0
			emit_signal("card_etb", player_card)
			player_card.attack_animation(player_card.card_stats.card_owner)
			player_card.effect(player_deck_list, enemy_deck_list, player, enemy)
			cooldown_keeper(player_card)

func play_order_check(player_card, enemy_card):
	if player_card.card_stats.priority > enemy_card.card_stats.priority:
		return player_card
	if enemy_card.card_stats.priority > player_card.card_stats.priority:
		return enemy_card
	if enemy.character_stats.speed > player.character_stats.speed:
		return enemy_card
	return player_card

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

func physical_damage_card(source, target, card = null):
	var crit = false
	
	apply_attack(source, card)
	apply_armor(target)
	apply_defense(target)

	if crit_check(card): 
		damage *= 2
		crit = true
	
	emit_signal("physical_damage", source, target, damage, card)
	ui.physical_damage_dealt(target, damage)
	change_health(target, damage)

func physical_damage_other(source, target, p_damage, card):
	damage = p_damage
	apply_armor(target)
	apply_defense(target)
	emit_signal("physical_damage", source, target, p_damage, card)
	ui.physical_damage_dealt(target, damage)
	change_health(target, damage)

func apply_attack(source, card):
	damage += card.card_stats.dmg + source.character_stats.attack

func apply_armor(target):
	damage -= target.character_stats.armor
	if damage < 0: damage = 0

func apply_defense(target):
	damage -= target.character_stats.defense
	if damage < 0: damage = 0

func reflect_damage(target, amount):
	print("In reflect damage")
	if target == enemy:
		change_health(true, amount)
		ui.change_player_reflect_number(amount)
	else:
		change_health(false, amount)
		ui.change_enemy_reflect_number(amount)

func bleed_func(source, target, card):
	if card.card_stats.bleed_dmg <= 0: return
	target.character_stats.bleeding_dmg += card.card_stats.bleed_dmg
	emit_signal("bleed_applied", source, target, card)

func add_bleed_damage(target, amount):
	target.character_stats.bleeding_dmg += amount

func bleed_damage_keeper(target):
	if target.character_stats.bleeding_dmg > 0:
		emit_signal("bleed_damage", target, target.character_stats.bleeding_dmg)
		change_health(target, target.character_stats.bleeding_dmg)
	if target.character_stats.bleeding_dmg> 0: target.character_stats.bleeding_dmg-= 1

func change_health(character, value):
	if character == player:
		Global.change_player_health(-value)
		player.change_player_health()
	
	else:
		Global.change_enemy_health(-value)
		enemy_node.change_enemy_health(-value)

func heal_func(source, target, card):
	var heal = card.card_stats.heal
	
	if crit_check(card): heal *= 2
	change_health(target, -heal)

func cooldown_keeper(card):
	card.card_stats.cd_remaining = card.card_stats.cd + 1
	card.card_stats.on_cd = true

#==================Non Battle Functions============================================================

func next_turn_handler():
	next_turn.next_turn()
	next_turn.visible = true
	$"../ContinueButton".visible = true

func end_fight_cleanup():
	next_turn.end_fight()
	$"../CardTransform".revert_cards()
	emit_signal("end_fight")
	$"../BattleRewards".update_rewards()
	$"../BattleRewards".visible = true
	
	next_turn.visible = true
	Global.enemy_active_deck = []
	for i in enemy_node.get_children():
		i.queue_free()
	$"../UI/Labels".visible = false

func _on_start_button_button_down():
	on_start()
	combat(player_deck_list, enemy_deck_list)

func on_start():
	emit_signal("start_of_battle")
	$"../StartButton".visible = false
	next_turn.visible = false
	$"../player_inventory".visible = false
	$"../ContinueButton".visible = false
	get_tree().get_nodes_in_group("character")[0].inventory_screen_toggle(false)
	$"../ConsumableManger".visible = true
	$"../ConsumableManger".process_mode = Node.PROCESS_MODE_INHERIT
	
	player_deck_list = player_deck.build_deck()
	enemy_deck_list = enemy_node.deck
	player_inventory_list = player_inventory.build_inventory()
	emit_signal("start_of_round")
	
func _on_continue_button_button_down():
	next_turn.visible = false
	$"../player_inventory".visible = false
	$"../ContinueButton".visible = false
	get_tree().get_nodes_in_group("character")[0].inventory_screen_toggle(false)
	$"../ConsumableManger".visible = true
	$"../ConsumableManger".process_mode = Node.PROCESS_MODE_INHERIT
	
	player_deck_list = player_deck.build_deck()
	enemy_deck_list = enemy_node.deck
	player_inventory_list = player_inventory.build_inventory()
	
	emit_signal("start_of_round")
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
			$"../TalentTree".visible = false

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


