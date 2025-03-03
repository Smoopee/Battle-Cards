extends Node2D

@onready var player_deck = $player_deck
@onready var enemy = $Enemy
@onready var player_skills = $PlayerSkills
@onready var player_character = $player_character
@onready var ui = $UI

var rng = RandomNumberGenerator.new()

var player_deck_list 
var enemy_deck_list
var player_skill_list = []
var enemy_skill_list = []
var player_armor = 0
var enemy_armor = 0
var turn_counter = 1


func combat(player_deck_list, enemy_deck_list):

	var turn_incrementer = 1

	print("It is turn " + str(turn_counter))
	buff_keeper()
	
	for i in range(0, 10):
		print(str(player_deck_list[i]))
		print(str(enemy_deck_list[i]))
		
		ui.change_player_card(player_deck_list[i].card_resource.card_art_path)
		ui.change_enemy_card(enemy_deck_list[i].card_resource.card_art_path)
		
		#                  Child 2 is where the card Node is at 
		player_deck_list[i].get_child(2).effect(player_deck_list, enemy_deck_list)
		print("Enemy deck card is " + str(enemy_deck_list[i].get_children()))
		enemy_deck_list[i].get_child(2).effect(player_deck_list, enemy_deck_list)
		
		damage_func(player_deck_list[i])
		damage_func(enemy_deck_list[i])
		
		heal_func(player_deck_list[i])
		heal_func(enemy_deck_list[i])
		
		await get_tree().create_timer(1).timeout
		
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
	
	if critical_strike_check <= i.card_resource.critical_strike_chance:
		print("CRIT!")
		return true
	else: return false

func damage_func(i):
	if i.card_resource.dmg <= 0: return
	var player_card = true
	if i.card_resource.in_enemy_deck: player_card = false
	var armor = enemy_armor
	if !player_card: armor = player_armor
	
	var damage = i.card_resource.dmg - armor
	if damage < 0: damage = 0
	
	if crit_check(i): damage *= 2
	print("THE DAMAGE IS " + str(damage) + " and the armor is " + str(armor))
	change_health(player_card, damage)

func change_health(character, value):
	if character:
		Global.change_enemy_health(-value)
		ui.change_player_damage_number(value)
		ui.change_enemy_health()
	else:
		Global.change_player_health(-value)
		ui.change_enemy_damage_number(value)
		ui.change_player_health()

func heal_func(i):
	if i.card_resource.heal <= 0: return
	var player_card = true
	if i.card_resource.in_enemy_deck: player_card = false
	
	var heal = i.card_resource.heal
	
	if crit_check(i): heal *= 2
	change_health(!player_card, -heal)

func buff_keeper():
	var buffs = get_tree().get_nodes_in_group("buff")
	for i in buffs:
		i.remove_counter()

func _on_button_button_down():
	
	player_deck_list = player_deck.build_deck()
	
	for i in player_deck_list:
		print(i.card_resource.upgrade_level)
	enemy_deck_list = enemy.build_deck() 
	
	
	player_skill_list = player_skills.add_skills()
	enemy_skill_list = enemy.add_skills()
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
		
	
