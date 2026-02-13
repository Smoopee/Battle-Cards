extends Node2D


var ability_y_position =  790 #1000 #
var ability_x_position = 960
var ability_array = []
var ability_width = 90


func _ready():
	set_abilities()

func set_abilities():
	print("Set Abilities")
	var player_abilities = Global.player_abilities

	for i in player_abilities:
		var new_instance = load(i.ability_scene_path).instantiate()
		new_instance.ability_stats = i
		add_child(new_instance)
		new_instance.get_node("BaseAbility").toggle_info_ui(true)
		new_instance.get_node("BaseAbility").update_ability_image()
		new_instance.set_ability()
	organize_abilities()


func add_ability(ability):
	print("Add ability")
	for i in get_children():
		if i.ability_stats.name == ability.name:
			i.get_node("BaseAbility").toggle_info_ui(true)
			return
			
	var new_instance = load(ability.ability_scene_path).instantiate()
	new_instance.ability_stats = ability
	add_child(new_instance)
	new_instance.get_node("BaseAbility").toggle_info_ui(true)
	new_instance.get_node("BaseAbility").update_ability_image()
	organize_abilities()

func organize_abilities():
	print("Organize Ability")
	print(get_children())
	var x_offset = 0
	for i in get_children():
		i.global_position = Vector2(x_offset + ability_x_position, ability_y_position)
		x_offset += 60
		
	#for i in get_children():
		#ability_array.push_front(i)
		#update_ability_positions()

func update_ability_positions():
	for i in range(ability_array.size()):
		var new_position = Vector2(calculate_ability_position(i), ability_y_position)
		var ability = ability_array[i]
		ability.global_position = new_position 

func calculate_ability_position(index):
	var total_width = (ability_array.size() - 1) * ability_width * Global.ui_scaler.x 
	var x_offset = Global.center_screen_x + index * ability_width * Global.ui_scaler.x - total_width / 2
	return x_offset

func get_ability_array():
	print("Get ability array")
	var ability_array = []
	for i in get_children():
		ability_array.push_back(i.ability_stats)
	
	return ability_array

func reset_abilities():
	print("Reset abilities")
	for i in get_children():
		remove_child(i)
		i.queue_free()
	
	set_abilities()

func enable_abilities():
	pass

func disable_abilities():
	pass
