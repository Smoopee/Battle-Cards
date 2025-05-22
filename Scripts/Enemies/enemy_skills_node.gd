extends Node2D

var rng = RandomNumberGenerator.new()

var enemy_skills = []
var skill_selection = []
var skill_db_reference
var difficulty
var selection_tags


func initialize_skills():
	skill_db_reference = preload("res://Resources/Skills/skill_db.gd")
	selection_tags = get_parent().get_parent().character_stats.selection_tags
	difficulty = get_parent().set_difficulty()
	get_skill_selection()
	create_skill_array()

func get_skill_selection():
	match difficulty:
		1:
			for i in skill_db_reference.ITEMS:
				var temp = load(skill_db_reference.ITEMS[i])
				print(temp.tags)
				for j in temp.tags:
					print("J is " + str(j))
					for k in selection_tags:
						print("K is " + str(k))
						if j.find(k) >= 0 and temp.rarity <= 1:
							skill_selection.push_back(temp)
		2:
			for i in skill_db_reference.ITEMS:
				var temp = load(skill_db_reference.ITEMS[i])
				for j in temp.tags:
					for k in selection_tags:
						if j.find(k) >= 0 and temp.rarity <= 1:
							skill_selection.push_back(temp)
		3:
			for i in skill_db_reference.ITEMS:
				var temp = load(skill_db_reference.ITEMS[i])
				for j in temp.tags:
					for k in selection_tags:
						if j.find(k) >= 0 and temp.rarity <= 1:
							skill_selection.push_back(temp)
		4:
			for i in skill_db_reference.ITEMS:
				var temp = load(skill_db_reference.ITEMS[i])
				for j in temp.tags:
					for k in selection_tags:
						if j.find(k) >= 0 and temp.rarity <= 1:
							skill_selection.push_back(temp)
		_:
			for i in skill_db_reference.ITEMS:
				var temp = load(skill_db_reference.ITEMS[i])
				for j in temp.tags:
					for k in selection_tags:
						if j.find(k) >= 0 and temp.rarity <= 1:
							skill_selection.push_back(temp)

func create_skill_array():
	for i in range(0, 1):
		var selection = random_skill_selection().duplicate()
		enemy_skills.push_front(selection)
	
	skill_upgrade_function()

func random_skill_selection():
	if skill_selection.size() == 0: return
	var skill_selection_index = rng.randi_range(0, skill_selection.size()-1)
	return skill_selection[skill_selection_index]

func skill_upgrade_function():
	match difficulty:
		1:
			for i in enemy_skills:
				i.upgrade_level = 1
		2:
			for i in enemy_skills:
				var upgrade_calc = rng.randi_range(0, 99)
				if upgrade_calc >= 70: i.upgrade_level = 2
				elif upgrade_calc >= 0: i.upgrade_level = 1
		3:
			for i in enemy_skills:
				var upgrade_calc = rng.randi_range(0, 99)
				if upgrade_calc >= 90: i.upgrade_level = 3
				elif upgrade_calc >= 60: i.upgrade_level = 2
				elif upgrade_calc >= 0: i.upgrade_level = 1
		4:
			for i in enemy_skills:
				var upgrade_calc = rng.randi_range(0, 99)
				if upgrade_calc >= 99: i.upgrade_level = 4
				elif upgrade_calc >= 70: i.upgrade_level = 3
				elif upgrade_calc >= 30: i.upgrade_level = 2
				elif upgrade_calc >= 0: i.upgrade_level = 1
		_:
			for i in enemy_skills:
				var upgrade_calc = rng.randi_range(0, 99)
				if upgrade_calc >= 95: i.upgrade_level = 4
				elif upgrade_calc >= 50: i.upgrade_level = 3
				elif upgrade_calc >= 0: i.upgrade_level = 2
