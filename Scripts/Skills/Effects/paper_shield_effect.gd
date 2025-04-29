extends Node2D


@onready var parent = $".."

var one_shot = true

func _ready():
	var stats = parent.skill_stats
	if Global.current_scene == "battle_sim":
		stats.owner.connect("physical_damage_taken", skill_effect)

func skill_effect(damage):
	print("In skills effect for paper shield")
	if one_shot == false: return
	if damage >= 6:
		get_tree().get_first_node_in_group("character").receiving_physical_dmg = 0
		one_shot = false
		print("WE BLOCKED WITH A PAPER SHIELD")
		parent.skill_image.self_modulate.a = .5
		parent.upgrade_border.self_modulate.a = .5

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
