extends Node2D

var enemy_deck = []
var enemy_skills = []
var enemy


func _ready():
	enemy = load(Global.current_enemy).instantiate()
	add_child(enemy)

func build_deck():
	enemy_deck = enemy.enemy_deck

	var deck_array = []
	var counter = 1
	
	for i in enemy_deck:
		var new_resource = i
		var new_instance = load(new_resource.card_scene_path).instantiate()
		add_child(new_instance)
		new_instance.card_stats.in_enemy_deck = true
		new_instance.card_stats.position = counter
		counter += 1
		deck_array.push_back(new_instance)
	
	return deck_array

func add_skills():
	enemy_skills = enemy.enemy_skills
	
	var skill_array = []
	print("Skill array is " + str(enemy_skills))
	
	for i in enemy_skills:
		var new_instance = i.instantiate()
		add_child(new_instance)
		print("This new skill is added! " + str(i))
		new_instance.player_skill = false
		skill_array.push_back(new_instance)

	return skill_array

