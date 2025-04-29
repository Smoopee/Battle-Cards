extends Node2D

@onready var parent = $".."

var one_shot = true

func _ready():
	var stats = parent.skill_stats
	if Global.current_scene == "battle_sim":
		stats.owner.connect("health_changed", skill_effect)

func skill_effect():
	var stats = parent.skill_stats
	if one_shot == false: return
	var max_health = float(stats.owner.character_stats.max_health)
	var health = float(stats.owner.character_stats.health)
	
	if health/max_health <= .2:
		stats.owner.change_attack(20)
		one_shot = false

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
