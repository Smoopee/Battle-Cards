extends Node2D

var player_skills = Global.player_skills

func add_skills():
	for i in player_skills:
		var new_instance = load(i).instantiate()
		add_child(new_instance)
		print("This new skill is added! " + str(i))
	
	var skill_array = []
	
	var skill_x_position = 0 
	for i in get_children():
		skill_array.push_back(i)
		i.position = Vector2(1400 + skill_x_position, 970)
		skill_x_position += 70
	
	return skill_array
