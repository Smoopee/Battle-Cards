extends Node2D


const ABILITY_Y_POSITION = 790

var ability_x_position = 0
var ability_array = []
var ability_width = 90


func _ready():
	set_abilities()

func set_abilities():
	var player_abilities = Global.player_abilities

	for i in player_abilities:
		var new_instance = load(i.ability_scene_path).instantiate()
		new_instance.ability_stats = i
		add_child(new_instance)
		new_instance.get_node("BaseAbility").toggle_info_ui(true)
		new_instance.get_node("BaseAbility").update_ability_image()
	organize_abilities()

func add_ability(ability):
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
	for i in get_children():
		i.scale = Vector2(1.5,1.5)
		ability_array.push_front(i)
		update_ability_positions()

func update_ability_positions():
	for i in range(ability_array.size()):
		var new_position = Vector2(calculate_ability_position(i), ABILITY_Y_POSITION)
		var ability = ability_array[i]
		ability.global_position = new_position 

func calculate_ability_position(index):
	var total_width = (ability_array.size() - 1) * ability_width * Global.ui_scaler.x 
	var x_offset = Global.center_screen_x + index * ability_width * Global.ui_scaler.x - total_width / 2
	return x_offset

func get_ability_array():
	var ability_array = []
	for i in get_children():
		ability_array.push_back(i.ability_stats)
	
	return ability_array

func enable_abilities():
	for i in get_tree().get_nodes_in_group("ability"):
		i.image_button.disabled = false

func disable_abilities():
	for i in get_tree().get_nodes_in_group("ability"):
		i.image_button.disabled = true
