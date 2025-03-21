extends Control

@onready var player_gold_label = $HBoxContainer/PlayerGold
@onready var player_xp_label = $HBoxContainer/PlayerXP
@onready var player_level_label = $HBoxContainer/PlayerLevel

func _ready():
	player_gold_label.text = "Gold: " + str(Global.player_gold)
	player_xp_label.text = "XP: " + str(Global.player_xp) + "/" + str(Global.xp_threshold)
	player_level_label.text = "Level: " + str(Global.player_level)

func change_player_gold():
	player_gold_label.text = "Gold: " + str(Global.player_gold)
	
