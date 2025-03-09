extends Control

@onready var player_damage_number = $PlayerDamageNumber
@onready var enemy_damage_number = $EnemyDamageNumber
@onready var combat_log = $ColorRect/RichTextLabel
func _ready():
	$EnemyBleedTaken.position = $"../Enemy".enemy.position + Vector2(10, 60)
	$EnemyBleedTaken.text = ""
func change_player_damage_number(value):
	player_damage_number.text = str(value) + " damage"

func change_enemy_damage_number(value):
	enemy_damage_number.text = str(value) + " damage"

func change_enemy_bleed_taken(value):
	$EnemyBleedTaken.text = str(value)
	if value <= 0: $EnemyBleedTaken.text = ""
	
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
