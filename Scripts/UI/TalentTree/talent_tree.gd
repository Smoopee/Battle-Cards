extends Control

@export var group1 = ButtonGroup.new()
@export var group2 = ButtonGroup.new()

var level = 3
var mouse_exit = false

func _ready():
	var talent_tree_reference = load("res://Scripts/Characters/Berserker/Talents/berserker_talents.gd")
	
	var counter = 0
	for i in talent_tree_reference.tier1_talents:
		var new_talent = load(i).instantiate()
		group1.get_buttons()[counter].add_child(new_talent)
		counter += 1
	for i in group1.get_buttons():
		i.get_child(0).text = i.get_child(1).talent_name
		
	if level < 2:
		for i in group1.get_buttons():
			i.disabled = true
			
	if level < 3:
		for i in group2.get_buttons():
			i.disabled = true

func _on_confirm_button_button_down():
	for i in get_tree().get_nodes_in_group("talent_button"):
		if i.button_pressed == false:
			i.disabled = true
			
	set_talent_array()

func set_talent_array():
	var talent_array = []
	var tier1_array = []
	var tier2_array = []
	
	for i in group1.get_buttons():
		if i.button_pressed: tier1_array.push_back(true)
		else: tier1_array.push_back(false)
			
	for i in group2.get_buttons():
		if i.button_pressed: tier2_array.push_back(true)
		else: tier2_array.push_back(false)
	
	talent_array.push_back(tier1_array)
	talent_array.push_back(tier2_array)
	print(talent_array)
	Global.player_talent_array = talent_array


func _on_texture_button_mouse_entered():
	mouse_exit = false
	await get_tree().create_timer(.5).timeout
	if mouse_exit == false: 
		Popups.talent_popup(Rect2i(Vector2i(global_position), Vector2i(0, 0)), $VBoxContainer/Tier1Buttons/TextureButton.get_child(1).talent_name, $VBoxContainer/Tier1Buttons/TextureButton.get_child(1).tooltip)

func _on_texture_button_mouse_exited():
	pass # Replace with function body.
	mouse_exit = true
	Popups.hide_talent_popup()
