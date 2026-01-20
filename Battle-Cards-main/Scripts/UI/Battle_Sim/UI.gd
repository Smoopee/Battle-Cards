extends Control


@onready var player_damage_number = $Labels/PlayerDamageNumber
@onready var enemy_damage_number = $Labels/EnemyDamageNumber
@onready var player_heal_number = $Labels/PlayerHealNumber
@onready var enemy_heal_number = $Labels/EnemyHealNumber
@onready var player_reflect_number = $Labels/PlayerReflectNumber
@onready var enemy_reflect_number = $Labels/EnemyReflectNumber
@onready var combat_log = $ColorRect/RichTextLabel
@onready var enemy_bleeding_label = $Labels/EnemyBleedTaken
@onready var player_bleeding_label = $Labels/PlayerBleedTaken
@onready var enemy_burning_label = $Labels/EnemyBurnTaken
@onready var player_burning_label = $Labels/PlayerBurnTaken
@onready var enemy_poisoning_label = $Labels/EnemyPoisonTaken
@onready var player_poisoning_label = $Labels/PlayerPoisonTaken

var player
var enemy
var center_screen_x
var center_screen_y

func _ready():
	player = get_tree().get_nodes_in_group("character")[0]
	enemy = get_tree().get_nodes_in_group("enemy")[0]
	
	enemy_bleeding_label.position = $"../Enemy".enemy.position + Vector2(35, 60)
	enemy_bleeding_label.text = ""
	player_bleeding_label.position = $"../Player".position + Vector2(35, -80)
	player_bleeding_label.text = ""
	enemy_burning_label.position = $"../Enemy".enemy.position + Vector2(15, 60)
	enemy_burning_label.text = ""
	player_burning_label.position = $"../Player".position + Vector2(15, -80)
	player_burning_label.text = ""
	enemy_poisoning_label.position = $"../Enemy".enemy.position + Vector2(-5, 60)
	enemy_poisoning_label.text = ""
	player_poisoning_label.position = $"../Player".position + Vector2(-5, -80)
	player_poisoning_label.text = ""
	
	
	combat_log.set_scroll_follow(true)
		
	center_screen_x = get_viewport().size.x / 2
	center_screen_y = get_viewport().size.y / 2
	connect_signals(get_tree().get_first_node_in_group("battle sim"))

func connect_signals(battle_sim):
	player.connect("physical_damage_taken", change_enemy_damage_number)
	enemy.connect("physical_damage_taken", change_player_damage_number)
	
	player.connect("heal_received", change_player_heal_number)
	enemy.connect("heal_received", change_enemy_heal_number)
	
	player.connect("bleeding_damage_taken", change_player_bleed_taken)
	enemy.connect("bleeding_damage_taken", change_enemy_bleed_taken)
	player.connect("bleeding_damage_applied", change_player_bleed_taken)
	enemy.connect("bleeding_damage_applied", change_enemy_bleed_taken)
	
	player.connect("burning_damage_taken", change_player_burn_taken)
	enemy.connect("burning_damage_taken", change_enemy_burn_taken)
	player.connect("burning_damage_applied", change_player_burn_taken)
	enemy.connect("burning_damage_applied", change_enemy_burn_taken)
	
	player.connect("poisoning_damage_taken", change_player_poison_taken)
	enemy.connect("poisoning_damage_taken", change_enemy_poison_taken)
	player.connect("poisoning_damage_applied", change_player_poison_taken)
	enemy.connect("poisoning_damage_applied", change_enemy_poison_taken)


	battle_sim.connect("end_of_round", end_of_round)


func physical_damage_dealt(target, damage):
	enemy = get_tree().get_nodes_in_group("enemy")[0]
	if target == enemy: 
		change_player_damage_number(damage)
	else: 
		change_enemy_damage_number(damage)

func change_player_damage_number(value):
	player_damage_number.modulate.a = 1
	var new_position =  Vector2(center_screen_x, center_screen_y + 60)
	player_damage_number.position = new_position
	var tween = get_tree().create_tween()
	tween.tween_property(player_damage_number, "position", new_position + Vector2(150, 0), 0.4)
	tween.tween_property(player_damage_number, "modulate:a", 0, .5)
	player_damage_number.text = str(value) 

func change_player_heal_number(value):
	if value <= 0: return
	player_heal_number.modulate.a = 1
	var new_position =  Vector2(center_screen_x, center_screen_y - 60)
	player_heal_number.position = new_position + Vector2(0, 130)
	var tween = get_tree().create_tween()
	tween.tween_property(player_heal_number, "position", new_position + Vector2(-150, 130), 0.4)
	tween.tween_property(player_heal_number, "modulate:a", 0, .5)
	player_heal_number.text = str(value) 
	print("In change player heal number")

func change_player_reflect_number(value):
	if value <= 0: return
	player_reflect_number.modulate.a = 1
	var new_position =  Vector2(center_screen_x, center_screen_y - 60)
	player_reflect_number.position = new_position 
	var tween = get_tree().create_tween()
	tween.tween_property(player_reflect_number, "position", new_position + Vector2(0, -130), 0.4)
	tween.tween_property(player_reflect_number, "z_index", 13, 0.4)
	tween.tween_property(player_reflect_number, "modulate:a", 0, .5)
	player_reflect_number.text = str(value) 

func change_enemy_damage_number(value):
	enemy_damage_number.modulate.a = 1
	var new_position =  Vector2(center_screen_x, center_screen_y - 60)
	enemy_damage_number.position = new_position
	var tween = get_tree().create_tween()
	tween.tween_property(enemy_damage_number, "position", new_position + Vector2(150, 0), 0.4)
	tween.tween_property(enemy_damage_number, "modulate:a", 0, .5)
	enemy_damage_number.text = str(value) 

func change_enemy_heal_number(value):
	if value <= 0: return
	enemy_heal_number.modulate.a = 1
	var new_position =  Vector2(center_screen_x, center_screen_y - 60)
	enemy_heal_number.position = new_position
	var tween = get_tree().create_tween()
	tween.tween_property(enemy_heal_number, "position", new_position + Vector2(-150, 130), 0.4)
	tween.tween_property(enemy_heal_number, "modulate:a", 0, .5)
	enemy_heal_number.text = str(value) 

func change_enemy_reflect_number(value):
	if value <= 0: return
	enemy_reflect_number.modulate.a = 1
	var new_position =  Vector2(center_screen_x, center_screen_y - 60)
	enemy_reflect_number.position = new_position 
	var tween = get_tree().create_tween()
	tween.tween_property(enemy_reflect_number, "position", new_position + Vector2(0, -130), 0.4)
	tween.tween_property(enemy_reflect_number, "z_index", 13, 0.4)
	tween.tween_property(enemy_reflect_number, "modulate:a", 0, .5)
	enemy_reflect_number.text = str(value) 

func change_enemy_bleed_taken(value):
	var enemy_drip = $Labels/EnemyBleedTaken/EnemyBleedDrip
	enemy_drip.visible = true
	var original_position = enemy_drip.position 
	enemy_drip.text = str(value)
	
	enemy_bleeding_label.text = str(value - 1)
	if value <= 1: enemy_bleeding_label.text = ""
	
	var tween = get_tree().create_tween()
	tween.tween_property(enemy_drip, "position", Vector2(enemy_drip.position.x, enemy_drip.position.y - 50), 0.5 * Global.COMBAT_SPEED)
	await tween.finished
	enemy_drip.visible = false
	enemy_drip.position = original_position

func change_player_bleed_taken(value):
	var player_drip = $Labels/PlayerBleedTaken/PlayerBleedDrip
	player_drip.visible = true
	var original_position = player_drip.position 
	player_drip.text = str(value)
	
	player_bleeding_label.text = str(value - 1)
	player_bleeding_label.scale = Vector2(1000, 1000)
	if value <= 1: player_bleeding_label.text = ""
	
	var tween = get_tree().create_tween()
	tween.tween_property(player_drip, "position", Vector2(player_drip.position.x, player_drip.position.y + 50), 0.5 * Global.COMBAT_SPEED)
	await tween.finished
	player_drip.visible = false
	player_drip.position = original_position

func change_enemy_burn_taken(value):
	var enemy_burnt = $Labels/EnemyBurnTaken/EnemyBurnt
	enemy_burnt.visible = true
	var original_position = enemy_burnt.position 
	enemy_burnt.text = str(value)
	
	enemy_burning_label.text = str(value)
	if value <= 1: enemy_burning_label.text = ""
	
	var tween = get_tree().create_tween()
	tween.tween_property(enemy_burnt, "position", Vector2(enemy_burnt.position.x, enemy_burnt.position.y - 50), 0.5 * Global.COMBAT_SPEED)
	await tween.finished
	enemy_burnt.visible = false
	enemy_burnt.position = original_position

func change_player_burn_taken(value):
	var player_burnt = $Labels/PlayerBurnTaken/PlayerBurnt
	player_burnt.visible = true
	var original_position = player_burnt.position 
	player_burnt.text = str(value)
	
	player_burning_label.text = str(value)
	if value <= 1: player_burning_label.text = ""
	
	var tween = get_tree().create_tween()
	tween.tween_property(player_burnt, "position", Vector2(player_burnt.position.x, player_burnt.position.y + 50), 0.5 * Global.COMBAT_SPEED)
	await tween.finished
	player_burnt.visible = false
	player_burnt.position = original_position

func change_enemy_poison_taken(value):
	var enemy_dose = $Labels/EnemyPoisonTaken/EnemyDose
	enemy_dose.visible = true
	var original_position = enemy_dose.position 
	enemy_dose.text = str(value)
	
	enemy_poisoning_label.text = str(value)
	if value <= 1: enemy_poisoning_label.text = ""
	
	var tween = get_tree().create_tween()
	tween.tween_property(enemy_dose, "position", Vector2(enemy_dose.position.x, enemy_dose.position.y - 50), 0.5 * Global.COMBAT_SPEED)
	await tween.finished
	enemy_dose.visible = false
	enemy_dose.position = original_position

func change_player_poison_taken(value):
	var player_dose = $Labels/PlayerPoisonTaken/PlayerDose
	player_dose.visible = true
	var original_position = player_dose.position 
	player_dose.text = str(value)
	
	player_poisoning_label.text = str(value)
	if value <= 1: player_poisoning_label.text = ""
	
	var tween = get_tree().create_tween()
	tween.tween_property(player_dose, "position", Vector2(player_dose.position.x, player_dose.position.y + 50), 0.5 * Global.COMBAT_SPEED)
	await tween.finished
	player_dose.visible = false
	player_dose.position = original_position

func end_of_round(value):
	$Labels/Rounds.text = "Round: " + str(value)




func update_combat_log_bleed(source, value, player, enemy, is_player, card, other):
	var red = Color(1.0,0.0,0.0,1.0)
	var black = Color(1.0,1.0,1.0,1.0)
	match source:
		"bleed_func":
			if is_player:
				combat_log.text += str(player.player_stats.name) + " is now bleeding for " + str(value) + " dmg!  "
				combat_log.text += "[color=green](" + str(player.player_stats.health) + ")[/color]" + "\n"
			else:
				combat_log.text += str(enemy.enemy_stats.name) + " is now bleeding for " + str(value) + " dmg!  "
				combat_log.text += "[color=red](" + str(enemy.enemy_stats.health) + ")[/color]" + "\n"
		"bleed_damage_keeper":
			if is_player:
				combat_log.text += str(player.player_stats.name) + " bled for " + str(value) + "!  "
				combat_log.text += "[color=green](" + str(player.player_stats.health) + ")[/color]" + "\n"
			else:
				combat_log.text += str(enemy.enemy_stats.name) + " bled for " + str(value) + "!  "
				combat_log.text += "[color=red](" + str(enemy.enemy_stats.health) + ")[/color]" + "\n"

func update_combat_log_damage_taken(value, player, enemy, is_player, card, crit):
	if is_player:
		combat_log.text += str(card.card_stats.name) + " hit " + str(player.player_stats.name) + " for " + str(value) + "!  "
		if crit: combat_log.text += " (Crit) "
		combat_log.text += "[color=green](" + str(player.player_stats.health) + ")[/color]" + "\n"
	else:
		combat_log.text += str(card.card_stats.name) + " hit " + str(enemy.enemy_stats.name) + " for " + str(value) + "!  "
		if crit: combat_log.text += " (Crit) "
		combat_log.text += "[color=red](" + str(enemy.enemy_stats.health) + ")[/color]" + "\n"

func update_combat_log_effect(effect):
	if effect == null: return
	combat_log.text += str(effect) + "\n"

func combat_log_break():
	combat_log.text += "--------------------------------------------------------------------" + "\n"
