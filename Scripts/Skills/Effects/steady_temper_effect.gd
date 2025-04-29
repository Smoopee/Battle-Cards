extends Node2D


@onready var parent = $".."


func _ready():
	if Global.current_scene == "battle_sim":
		get_tree().get_first_node_in_group("battle sim").connect("start_of_battle", skill_effect)

func skill_effect():
	var stats = parent.skill_stats
	stats.owner.rage_degeneration = 0
	print("In steady temper skill")

func upgrade_skill(num):
	parent = $".."
	var stats = parent.skill_stats
	
	match num:
		1:
			stats.skill_upgrade_art_path = "res://Resources/Art/Skills/skill_upgrade1.png"
			stats.upgrade_level = 1
			stats.buy_price = 2
		2: 
			stats.skill_upgrade_art_path = "res://Resources/Art/Skills/skill_upgrade2.png"
			stats.upgrade_level = 2
			stats.buy_price = 4
		3:
			stats.skill_upgrade_art_path = "res://Resources/Art/Skills/skill_upgrade3.png"
			stats.upgrade_level = 3
			stats.buy_price = 8
		4:
			stats.skill_upgrade_art_path = "res://Resources/Art/Skills/skill_upgrade4.png"
			stats.upgrade_level = 4
			stats.buy_price = 16
		
	parent.update_skill_image()
