extends Node2D

signal end_of_turn
signal end_of_round
signal start_of_turn
signal start_of_battle
signal start_of_round
signal card_etb
signal end_fight


#===================================================================================================
var current_screen = ""

@onready var player_deck = $"../player_deck"
@onready var enemy_node = $"../Enemy"
@onready var ui = $"../UI"
@onready var player_node = $"../Player"
@onready var next_turn = $"../NextTurn"
@onready var timer_between_animations = $"../AnimationTimer"
@onready var play_order_timer = $"../PlayOrder"

var rng = RandomNumberGenerator.new()

var player_inventory_list
var player_deck_list 
var enemy_deck_list
var round_counter = 1
var round_limit = 10

var enemy
var player
var player_card
var enemy_card

var physical_damage


func _ready():
	connect_signal_setup()
	timer_between_animations.wait_time *= Global.COMBAT_SPEED
	play_order_timer.wait_time *= Global.COMBAT_SPEED
	
	player_deck_list = $"../player_deck".set_deck()
	enemy_deck_list = enemy_node.initial_build_deck()
	
	emit_signal("start_of_battle")

func connect_signal_setup():
	enemy = get_tree().get_nodes_in_group("enemy")[0] 
	player = get_tree().get_nodes_in_group("character")[0]

	player.connect_signals(self)
	enemy.connect_signals(self)

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
		i.get_node("BaseCard").disable_collision()
	for i in enemy_deck_list:
		i.get_node("BaseCard").disable_collision()
	
	for i in range(0, 10):
		emit_signal("start_of_turn")
		player_card = player_deck_list[i]
		enemy_card = enemy_deck_list[i]
		
		player_deck.play_card(player_card)
		enemy_node.play_card(enemy_card)
		
		await get_tree().create_timer(.6 * Global.COMBAT_SPEED).timeout
		
		play_card()
		
		await get_tree().create_timer(.6 * Global.COMBAT_SPEED).timeout
		
		timer_between_animations.start()
		await timer_between_animations.timeout
		player_deck.discard(player_card)
		enemy_node.discard(enemy_card)
		
		timer_between_animations.start()
		await timer_between_animations.timeout
		
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
		if !player_card.card_stats.on_cd and stun_check(player_card.card_stats.owner): 
			emit_signal("card_etb", player_card)
			player_card.get_node("BaseCard").attack_animation(player_card.card_stats.owner)
			player_card.effect(player_deck_list, enemy_deck_list, player, enemy)
			cooldown_keeper(player_card)
		
		play_order_timer.start()
		await play_order_timer.timeout
		
		if !enemy_card.card_stats.on_cd and stun_check(enemy_card.card_stats.owner):
			emit_signal("card_etb", enemy_card)
			enemy_card.get_node("BaseCard").attack_animation(enemy_card.card_stats.owner)
			enemy_card.effect(player_deck_list, enemy_deck_list, player, enemy)
			cooldown_keeper(enemy_card)
	else:
		if !enemy_card.card_stats.on_cd and stun_check(enemy_card.card_stats.owner): 
			emit_signal("card_etb", enemy_card)
			enemy_card.attack_animation(enemy_card.card_stats.owner)
			enemy_card.effect(player_deck_list, enemy_deck_list, player, enemy)
			cooldown_keeper(enemy_card)
		
		play_order_timer.start()
		await play_order_timer.timeout
		
		if !player_card.card_stats.on_cd and stun_check(player_card.card_stats.owner):
			emit_signal("card_etb", player_card)
			player_card.attack_animation(player_card.card_stats.owner)
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
	if player.character_stats.health <= 0: 
		print("You have Died!")
		return true
	else: false
	
	if enemy.character_stats.health <= 0: 
		end_fight_cleanup()
		return true
	else: false

func crit_check(i):
	var critical_strike_check = rng.randf_range(0, 1)
	
	if critical_strike_check <= i.card_stats.critical_strike_chance:
		return true
	else: return false

func cooldown_keeper(card):
	card.card_stats.cd_remaining = card.card_stats.cd + 1
	if card.card_stats.cd_remaining <= 1: 
		card.card_stats.cd_remaining == 0
	else:
		card.card_stats.on_cd = true

func stun_check(character):
	if character.character_stats.is_stunned == true: 
		return false
	else: return true

#==================Non Battle Functions============================================================

func next_turn_handler():
	next_turn.next_turn()
	next_turn.visible = true
	$"../ContinueButton".visible = true

func end_fight_cleanup():
	next_turn.end_fight()
	emit_signal("end_fight")
	$"../CardTransform".revert_cards()
	$"../BattleRewards".update_rewards()
	$"../BattleRewards".visible = true
	
	next_turn.visible = true
	Global.enemy_active_deck = []
	for i in enemy_node.get_children():
		i.queue_free()
	$"../UI/Labels".visible = false

func _on_start_button_button_down():
	during_combat_ui_toggle()
	emit_signal("start_of_round")
	combat(player_deck_list, enemy_deck_list)


func _on_continue_button_button_down():
	during_combat_ui_toggle()
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

func during_combat_ui_toggle():
	$"../StartButton".visible = false
	$"../ContinueButton".visible = false
	$"../ConsumableManger".visible = true
	$"../ConsumableManger".process_mode = Node.PROCESS_MODE_INHERIT
	
	get_tree().get_nodes_in_group("character")[0].inventory_screen_toggle(false)
	get_tree().get_first_node_in_group("player cards").toggle_combat_ui(true)
	
	player_deck_list = player_deck.build_deck()
	enemy_deck_list = enemy_node.deck
	player_inventory_list = get_tree().get_first_node_in_group("player cards").inventory_card_slot_reference
	
	for i in player_inventory_list:
		if i == null: continue
		i.visible = false
	
