extends Node2D

@onready var xp_reward_label = $TextureRect/HBoxContainer/VariableContainer/XpReward
@onready var gold_reward_label = $TextureRect/HBoxContainer/VariableContainer/GoldReward
@onready var player_gold_label = $TextureRect/HBoxContainer/VariableContainer/Gold
@onready var player_xp_label = $TextureRect/HBoxContainer/VariableContainer/Xp


func update_rewards():
	xp_reward_label.text = str(Global.current_enemy.xp)
	gold_reward_label.text = str(Global.current_enemy.gold)
	
	player_gold_label.text = str(Global.player_gold)
	player_xp_label.text = str(Global.player_xp)

func _on_button_button_down():
	get_tree().change_scene_to_file(("res://Scenes/UI/Intermission/intermission.tscn"))
