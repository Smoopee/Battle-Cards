extends Control

@export var group1 = ButtonGroup.new()
@export var group2 = ButtonGroup.new()

@onready var level = Global.player_level
var talent_tree_reference = load("res://Scripts/Characters/Berserker/Talents/berserker_talents.gd")
var mouse_exit = false


func _ready():
	create_talent_tree()
	load_player_selected_talents()
	disable_out_of_reach_talents()

func _on_confirm_button_button_down():
	for i in get_tree().get_nodes_in_group("talent_button"):
		if i.button_pressed == false:
			i.disabled = true
			
	save_talent_array()

func save_talent_array():
	var talent_array = []
	var tier1_talent
	var tier2_talent
	
	for i in group1.get_buttons():
		if i.button_pressed: tier1_talent = i.get_child(0).talent_scene_path
			
	for i in group2.get_buttons():
		if i.button_pressed: tier2_talent =  i.get_child(0).talent_scene_path
	
	talent_array.push_back(tier1_talent)
	talent_array.push_back(tier2_talent)
	Global.player_talent_array = talent_array

func create_talent_tree():
	var new_talent
	var counter = 0
	for i in talent_tree_reference.tier1_talents:
		new_talent = load(i).instantiate()
		group1.get_buttons()[counter].add_child(new_talent)
		counter += 1
	for i in group1.get_buttons():
		i.texture_normal = load(i.get_child(0).not_pressed_texture)
		i.texture_hover = load(i.get_child(0).hover_texture)
		i.texture_pressed = load(i.get_child(0).pressed_texture)
		i.texture_disabled = load(i.get_child(0).disabled_texture)
		
	counter = 0
	for i in talent_tree_reference.tier2_talents:
		new_talent = load(i).instantiate()
		group2.get_buttons()[counter].add_child(new_talent)
		counter += 1
	for i in group2.get_buttons():
		i.texture_normal = load(i.get_child(0).not_pressed_texture)
		i.texture_hover  = load(i.get_child(0).hover_texture)
		i.texture_pressed = load(i.get_child(0).pressed_texture)
		i.texture_disabled = load(i.get_child(0).disabled_texture)

func load_player_selected_talents():
	for i in group1.get_buttons():
		for j in Global.player_talent_array:
			if i.get_child(0).talent_scene_path == j:
				i.button_pressed = true
	
	for i in group2.get_buttons():
		for j in Global.player_talent_array:
			if i.get_child(0).talent_scene_path == j:
				i.button_pressed = true
				
	#Disables the non players ones ============================================================
	for i in get_tree().get_nodes_in_group("talent_button"):
		if i.button_pressed == false:
			i.disabled = true

func disable_out_of_reach_talents():
	if level < 2:
		for i in group1.get_buttons():
			i.disabled = true
			
	if level < 3:
		for i in group2.get_buttons():
			i.disabled = true

func _on_texture_button_mouse_entered():
	pass

func _on_texture_button_mouse_exited():
	pass

func _on_reset_button_button_down():
	for i in get_tree().get_nodes_in_group("talent_button"):
		i.button_pressed = false
		i.disabled = false
		Global.player_talent_array = []
