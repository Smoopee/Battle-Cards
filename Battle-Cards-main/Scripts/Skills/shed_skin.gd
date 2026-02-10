extends Node2D


@onready var stats = skill_stats
@onready var skill = $BaseSkill

var skill_stats: Skills_Resource = null

var one_shot = true

func _ready():
	if Global.current_scene == "battle_sim":
		stats.owner.connect("staggered", skill_effect)

func skill_effect():
	if one_shot == false: return
	stats.owner.character_stats.can_be_staggered = false
	stats.owner.character_stats.stagger = 0
	stats.owner.change_stagger(0)
	one_shot = false
	skill.skill_image.self_modulate.a = .5
	skill.upgrade_border.self_modulate.a = .5
	get_tree().get_first_node_in_group("battle sim").connect("end_of_turn", skill_effect2)

func skill_effect2():
	stats.owner.character_stats.can_be_staggered = true
	stats.owner.disconnect("staggered", skill_effect)
	get_tree().get_first_node_in_group("battle sim").disconnect("end_of_turn", skill_effect2)

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
	"Prevents being stunned from stagger. One Shot", 
	"Effect: ")
	skill.update_skill_image()
