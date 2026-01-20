extends Node2D


@onready var parent = $".."

var counter = 0

func _ready():
	if Global.current_scene == "battle_sim":
		get_tree().get_first_node_in_group("enemy deck").connect("build_enemy_deck", skill_effect1)
	
	if Global.current_scene == "battle_sim":
		get_tree().get_first_node_in_group("battle sim").connect("start_of_turn", skill_effect2)

func skill_effect1():
	var rng = RandomNumberGenerator.new()
	counter = rng.randi_range(1, 10)
	print("In thump skill effect")
	parent.info_label.visible = true
	parent.info_label.text = str(counter)

func skill_effect2():
	var stats = parent.skill_stats
	if counter == 0: return
	counter -= 1
	parent.info_label.text = str(counter)
	if counter == 0: 
		stats.target.character_stats.stun_counter = 2
		stats.target.stun_toggle(true)
		parent.info_label.visible = false

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

func update_counter_text():
	parent.info_label.text = str(counter)
