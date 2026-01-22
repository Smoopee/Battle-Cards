extends Node2D


@onready var stats = skill_stats
@onready var skill = $BaseSkill

var skill_stats: Skills_Resource = null

var one_shot = true

func _ready():
	if Global.current_scene == "battle_sim":
		stats.owner.connect("physical_damage_taken", skill_effect)

func skill_effect(damage):
	if one_shot == false: return
	if damage >= 6:
		get_tree().get_first_node_in_group("character").receiving_physical_dmg = 0
		one_shot = false
		skill.skill_image.self_modulate.a = .5
		skill.upgrade_border.self_modulate.a = .5

func upgrade_skill(num):
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
			
	skill.update_tooltip(str(stats.name), 
	"Effect", 
	"The first hit 6 or Greater is 0", 
	"Effect: ")
	skill.update_skill_image()
