extends Control


@onready var player_damage_number = $Labels/PlayerDamageNumber
@onready var enemy_damage_number = $Labels/EnemyDamageNumber
@onready var combat_log = $ColorRect/RichTextLabel
@onready var enemy_bleeding_label = $Labels/EnemyBleedTaken
@onready var player_bleeding_label = $Labels/PlayerBleedTaken

var center_screen_x
var center_screen_y

func _ready():
	enemy_bleeding_label.position = $"../Enemy".enemy.position + Vector2(35, 60)
	enemy_bleeding_label.text = ""
	player_bleeding_label.position = $"../Player".position + Vector2(35, -80)
	player_bleeding_label.text = ""
	combat_log.set_scroll_follow(true)
		
	center_screen_x = get_viewport().size.x / 2
	center_screen_y = get_viewport().size.y / 2

func change_player_damage_number(value, crit):
	player_damage_number.modulate.a = 1
	var new_position =  Vector2(center_screen_x, center_screen_y + 60)
	player_damage_number.position = new_position
	var tween = get_tree().create_tween()
	tween.tween_property(player_damage_number, "position", new_position + Vector2(150, 0), 0.4)
	tween.tween_property(player_damage_number, "modulate:a", 0, .5)
	player_damage_number.text = str(value) 

func change_enemy_damage_number(value, crit):
	enemy_damage_number.set("theme_override_font_sizes/font_size", 33)
	enemy_damage_number.modulate.a = 1
	var new_position =  Vector2(center_screen_x, center_screen_y - 60)
	enemy_damage_number.position = new_position
	var tween = get_tree().create_tween()
	if crit:
		tween.tween_property(enemy_damage_number, "theme_override_font_sizes/font_size", 60, 0)
	tween.tween_property(enemy_damage_number, "position", new_position + Vector2(150, 0), 0.4)
	tween.tween_property(enemy_damage_number, "modulate:a", 0, .5)
	enemy_damage_number.text = str(value) 

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
	if value <= 1: player_bleeding_label.text = ""
	
	var tween = get_tree().create_tween()
	tween.tween_property(player_drip, "position", Vector2(player_drip.position.x, player_drip.position.y + 50), 0.5 * Global.COMBAT_SPEED)
	await tween.finished
	player_drip.visible = false
	player_drip.position = original_position

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
