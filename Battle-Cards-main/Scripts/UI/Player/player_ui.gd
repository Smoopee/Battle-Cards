extends Control

@onready var player_gold_label = $HBoxContainer/PlayerGold
@onready var player_xp_label = $HBoxContainer/PlayerXP
@onready var player_level_label = $HBoxContainer/PlayerLevel
@onready var current_battle = $HBoxContainer/CurrentBattle

func _ready():
	set_labels()

func change_player_gold():
	player_gold_label.text = "Gold: " + str(Global.player_gold)

func set_labels():
	player_gold_label.text = "Gold: " + str(Global.player_gold)
	player_xp_label.text = "XP: " + str(Global.player_xp) + "/" + str(Global.xp_threshold)
	player_level_label.text = "Level: " + str(Global.player_level)
	current_battle.text = "Battle: " + str(Global.battle_tracker)
