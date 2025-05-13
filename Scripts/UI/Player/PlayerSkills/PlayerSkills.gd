extends Node2D

const SKILL_X_POSITION = 600
const SKILL_Y_POSITION = -40

func _ready():
	set_skills()

#SKILLS ===========================================================================================
func set_skills():
	var player_skills = Global.player_skills

	for i in player_skills:
		var new_instance = load(i.skill_scene_path).instantiate()
		new_instance.skill_stats = i
		new_instance.skill_stats.owner = get_tree().get_first_node_in_group("character")
		new_instance.skill_stats.target = get_tree().get_first_node_in_group("enemy")
		add_child(new_instance)
		new_instance.upgrade_skill(new_instance.skill_stats.upgrade_level)
		
	
	organize_skills()

func add_skill(skill):
	var new_instance = load(skill.skill_scene_path).instantiate()
	new_instance.skill_stats = skill
	new_instance.skill_stats.owner = get_tree().get_first_node_in_group("character")
	print(new_instance.skill_stats.owner)
	add_child(new_instance)
	new_instance.upgrade_skill(new_instance.skill_stats.upgrade_level)
	organize_skills()

func organize_skills():
	var x_offset = 0
	for i in get_children():
		i.position = Vector2(x_offset + SKILL_X_POSITION, SKILL_Y_POSITION)
		x_offset += 60
