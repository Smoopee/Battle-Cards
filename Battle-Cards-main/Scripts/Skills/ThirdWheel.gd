extends Node2D

@onready var stats = skill_stats
@onready var skill = $BaseSkill

var skill_stats: Skills_Resource = null

var counter = 0

func _ready():
	if Global.current_scene == "battle_sim":
		get_tree().get_first_node_in_group("battle sim").connect("card_etb", skill_effect)

func skill_effect(card):
	if card.card_stats.owner != stats.owner: return
	skill.info_label.visible = true
	if card.card_stats.card_type.find("Attack") >= 0:
		if counter >=2:
			stats.owner.temp_physical_damage += 5
			counter = 0
		else:
			counter += 1
			
		update_counter_text()

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
	"Every Third Attack in a row increased by 5", 
	"Effect: ")
	skill.update_skill_image()

func update_counter_text():
	skill.info_label.text = str(counter)
