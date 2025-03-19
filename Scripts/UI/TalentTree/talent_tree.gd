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
		if i.button_pressed: tier1_talent = i.get_child(1).talent_scene_path
			
	for i in group2.get_buttons():
		if i.button_pressed: tier2_talent =  i.get_child(1).talent_scene_path
	
	talent_array.push_back(tier1_talent)
	talent_array.push_back(tier2_talent)
	Global.player_talent_array = talent_array

func create_talent_tree():
	
	var counter = 0
	for i in talent_tree_reference.tier1_talents:
		var new_talent = load(i).instantiate()
		group1.get_buttons()[counter].add_child(new_talent)
		counter += 1
	for i in group1.get_buttons():
		i.get_child(0).text = i.get_child(1).talent_name
	
	counter = 0
	for i in talent_tree_reference.tier2_talents:
		var new_talent = load(i).instantiate()
		group2.get_buttons()[counter].add_child(new_talent)
		counter += 1
	for i in group2.get_buttons():
		i.get_child(0).text = i.get_child(1).talent_name

func load_player_selected_talents():
	for i in group1.get_buttons():
		for j in Global.player_talent_array:
			if i.get_child(1).talent_scene_path == j:
				i.button_pressed = true
	
	for i in group2.get_buttons():
		for j in Global.player_talent_array:
			if i.get_child(1).talent_scene_path == j:
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
	mouse_exit = false
	await get_tree().create_timer(.5).timeout
	if mouse_exit == false: 
		Popups.talent_popup(Rect2i(Vector2i(global_position), Vector2i(0, 0)), $VBoxContainer/Tier1Buttons/TextureButton.get_child(1).talent_name, $VBoxContainer/Tier1Buttons/TextureButton.get_child(1).tooltip)
	
func _on_texture_button_mouse_exited():
	pass # Replace with function body.
	mouse_exit = true
	Popups.hide_talent_popup()

func _on_reset_button_button_down():
	for i in get_tree().get_nodes_in_group("talent_button"):
		i.button_pressed = false
		i.disabled = false
		Global.player_talent_array = []
