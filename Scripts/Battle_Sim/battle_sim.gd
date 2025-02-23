extends Node2D

@onready var player_deck = $player_deck
@onready var enemy_deck = $enemy_deck
@onready var player_character = $player_character
@onready var ui = $UI

var rng = RandomNumberGenerator.new()

var dmg_multiplier = 1

func _ready():
	combat()

func build_deck():
	var deck_array = []
	var counter = 1
	
	player_deck.build_deck()
	
	for i in player_deck.get_children():
		deck_array.push_back(i)
	
	for i in deck_array:
		i.card_stats.position = counter
		counter += 1
	
	return deck_array

func build_enemy_deck():
	var deck_array = []
	var counter = 1
	
	enemy_deck.build_deck()
	
	for i in enemy_deck.get_children():
		i.card_stats.in_enemy_deck = true
		deck_array.push_back(i)
	
	for i in deck_array:
		i.card_stats.position = counter
		counter += 1
	
	return deck_array

func combat():
	var player_deck_list = build_deck()
	var enemy_deck_list = build_enemy_deck()
	#var both_deck_list = merge_deck_lists(player_deck_list, enemy_deck_list)
	
	var turn_counter = 1
	var turn_incrementer = 1
	var turn_end = 30
	
	var player_block = 0
	var enemy_block = 0
	
	while turn_counter < turn_end:
		print("It is turn " + str(turn_counter))
		buff_keeper()
		
		for i in range(0, 10):
			print(str(player_deck_list[i]))
			print(str(enemy_deck_list[i]))
			
			ui.change_player_card(player_deck_list[i].card_stats.card_art_path)
			ui.change_enemy_card(enemy_deck_list[i].card_stats.card_art_path)
			
			
			player_deck_list[i].effect(player_deck_list, enemy_deck_list)
			enemy_deck_list[i].effect(player_deck_list, enemy_deck_list)
			
			damage_func(player_deck_list[i])
			damage_func(enemy_deck_list[i])
			
			heal_func(player_deck_list[i])
			heal_func(enemy_deck_list[i])
			
			await get_tree().create_timer(1).timeout
			if death_checker(): break
		if death_checker(): break
		
		player_block = 0
		enemy_block = 0
		turn_counter += turn_incrementer
		
		

#func merge_deck_lists(player_deck, enemy_deck):
	#var merged_deck_list = []
	#var counter = 0
	#
	#for i in player_deck:
		#merged_deck_list.push_back(i)
		#merged_deck_list.push_back(enemy_deck[counter])
		#counter += 1
	#
	#return merged_deck_list

func death_checker():
	if Global.player_health <= 0: 
		print("You have Died!")
		return true
	else: false
	
	if Global.enemy_health <= 0: 
		print("The enemy has been defeated!")
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

	
	if crit_check(i): crit = true
	
	if crit == true:
		if i.card_stats.in_enemy_deck:
			Global.change_player_health(-i.card_stats.dmg*2)
			ui.change_enemy_damage_number(i.card_stats.dmg*2)
			print("Their " + str(i.card_stats.name) + " crit for " + str(i.card_stats.dmg * 2))
			print("Player's health is " +  str(Global.player_health))
		else:
			Global.change_enemy_health(-i.card_stats.dmg*2)
			ui.change_player_damage_number(i.card_stats.dmg*2)
			print("Your " + str(i.card_stats.name) + " crit for " + str(i.card_stats.dmg * 2))
			print("Enemy's health is " +  str(Global.enemy_health))
	else:
		if i.card_stats.in_enemy_deck:
			Global.change_player_health(-i.card_stats.dmg)
			ui.change_enemy_damage_number(i.card_stats.dmg)
			print("Their " + str(i.card_stats.name) + " hit for " + str(i.card_stats.dmg))
			print("Players's health is " +  str(Global.player_health))
		else:
			Global.change_enemy_health(-i.card_stats.dmg)
			ui.change_player_damage_number(i.card_stats.dmg)
			print("IN THE LOOP THE DAMAGE IS " + str(i.card_stats.dmg))
			print("Your " + str(i.card_stats.name) + " hit for " + str(i.card_stats.dmg))
			print("Enemy's health is " +  str(Global.enemy_health))
	
	ui.change_player_health(Global.player_health)
	ui.change_enemy_health(Global.enemy_health)

func heal_func(i):
	if i.card_stats.heal <= 0: return
	var crit = false
	
	if crit_check(i): crit = true
	
	if crit == true:
		if i.card_stats.in_enemy_deck:
			Global.change_enemy_health(i.card_stats.heal*2)
			print("Their " + str(i.card_stats.name) + " crit for " + str(i.card_stats.heal * 2))
			print("Enemy's health is " +  str(Global.enemy_health))
		else:
			Global.change_player_health(i.card_stats.heal*2)
			print("Your " + str(i.card_stats.name) + " crit for " + str(i.card_stats.heal * 2))
			print("Players's health is " +  str(Global.player_health))
	else:
		if i.card_stats.in_enemy_deck:
			Global.change_enemy_health(i.card_stats.heal)
			print("Their " + str(i.card_stats.name) + " healed for " + str(i.card_stats.heal))
			print("Enemy's health is " +  str(Global.enemy_health))
		else:
			Global.change_player_health(i.card_stats.heal)
			print("Your " + str(i.card_stats.name) + " healed for " + str(i.card_stats.heal))
			print("Player's health is " +  str(Global.player_health))

func buff_keeper():
	var buffs = get_tree().get_nodes_in_group("buff")
	for i in buffs:
		i.remove_counter()


