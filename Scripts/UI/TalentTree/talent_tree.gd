extends Control

@export var group1 = ButtonGroup.new()
@export var group2 = ButtonGroup.new()
@onready var level = Global.player_level
var talent_tree_reference = load("res://Scripts/Characters/Berserker/Talents/berserker_talents.gd")

var tier1_access = false
var tier2_access = false

var tier1_chosen = false
var tier2_chosen = false

func _ready():
	Global.connect("level_up", level_up)
	create_talent_tree()
	talent_access_check()
	disable_out_of_reach_talents()
	load_player_selected_talents()
	talent_alert_check()

func talent_access_check():
	if Global.player_level >= 4: tier1_access = true
	if Global.player_level >= 7: tier2_access = true

func talent_alert_check():
	if tier1_access && !tier1_chosen: 
		get_tree().get_first_node_in_group("bottom ui").talent_alert_toggle(true)
		return
	if tier2_access && !tier2_chosen: 
		get_tree().get_first_node_in_group("bottom ui").talent_alert_toggle(true)
		return

func level_up():
	if Global.player_level >= 4: 
		tier1_access = true
		get_tree().get_first_node_in_group("bottom ui").talent_alert_toggle(true)
		disable_out_of_reach_talents()
	if Global.player_level >= 7: 
		tier2_access = true
		get_tree().get_first_node_in_group("bottom ui").talent_alert_toggle(true)
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
		tier1_chosen = true
			
	for i in group2.get_buttons():
		if i.button_pressed: tier2_talent =  i.get_child(0).talent_scene_path
		tier2_chosen = true
	
	talent_array.push_back(tier1_talent)
	talent_array.push_back(tier2_talent)
	Global.player_talent_array = talent_array
	
	if tier1_chosen == true and tier1_access: 
		get_tree().get_first_node_in_group("bottom ui").talent_alert_toggle(false)

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
				tier1_chosen = true
	
	for i in group2.get_buttons():
		for j in Global.player_talent_array:
			if i.get_child(0).talent_scene_path == j:
				i.button_pressed = true
				tier2_chosen = true


func disable_out_of_reach_talents():
	if !tier1_access:
		for i in group1.get_buttons():
			i.disabled = true
		$VBoxContainer2/Tier1Block.visible = true
	else:
		for i in group1.get_buttons():
			i.disabled = false
		$VBoxContainer2/Tier1Block.visible = false
	if !tier2_access:
		for i in group2.get_buttons():
			i.disabled = true
		$VBoxContainer2/Tier2Block.visible = true
	else:
		for i in group2.get_buttons():
			i.disabled = false
		$VBoxContainer2/Tier2Block.visible = false

func _on_texture_button_mouse_entered():
	pass

func _on_texture_button_mouse_exited():
	pass

func _on_reset_button_button_down():
	for i in get_tree().get_nodes_in_group("talent_button"):
		i.button_pressed = false
		i.disabled = false
		Global.player_talent_array = []
	
	disable_out_of_reach_talents()
