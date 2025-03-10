extends Control

@onready var player_gold_label = $VBoxContainer/PlayerGold
@onready var player_xp_label = $VBoxContainer/PlayerXP

func _ready():
	player_gold_label.text = "Gold: " + str(Global.player_gold)
	player_xp_label.text = "XP: " + str(Global.player_xp)

func change_player_gold():
	player_gold_label.text = "Gold: " + str(Global.player_gold)
	
