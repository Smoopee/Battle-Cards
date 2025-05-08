extends Control

@export var group1 = ButtonGroup.new()
@export var group2 = ButtonGroup.new()
@export var group3 = ButtonGroup.new()
@export var group4 = ButtonGroup.new()
@export var group5 = ButtonGroup.new()
@export var group6 = ButtonGroup.new()
@export var group7 = ButtonGroup.new()
@export var group8 = ButtonGroup.new()

@onready var level = Global.player_level
var talent_tree_reference = load("res://Scripts/Characters/Berserker/Talents/berserker_talents.gd")

var tier1_access = false
var tier2_access = false
var tier3_access = false
var tier4_access = false
var tier5_access = false
var tier6_access = false
var tier7_access = false
var tier8_access = false


var tier1_chosen = false
var tier2_chosen = false
var tier3_chosen = false
var tier4_chosen = false
var tier5_chosen = false
var tier6_chosen = false
var tier7_chosen = false
var tier8_chosen = false


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
	if Global.player_level >= 10: tier3_access = true
	if Global.player_level >= 13: tier4_access = true
	if Global.player_level >= 16: tier5_access = true
	if Global.player_level >= 19: tier6_access = true
	if Global.player_level >= 22: tier7_access = true
	if Global.player_level >= 25: tier8_access = true
	
func talent_alert_check():
	if tier1_access && !tier1_chosen: 
		get_tree().get_first_node_in_group("bottom ui").talent_alert_toggle(true)
		return
	if tier2_access && !tier2_chosen: 
		get_tree().get_first_node_in_group("bottom ui").talent_alert_toggle(true)
		return
	if tier3_access && !tier3_chosen: 
		get_tree().get_first_node_in_group("bottom ui").talent_alert_toggle(true)
		return
	if tier4_access && !tier4_chosen: 
		get_tree().get_first_node_in_group("bottom ui").talent_alert_toggle(true)
		return
	if tier5_access && !tier5_chosen: 
		get_tree().get_first_node_in_group("bottom ui").talent_alert_toggle(true)
		return
	if tier6_access && !tier6_chosen: 
		get_tree().get_first_node_in_group("bottom ui").talent_alert_toggle(true)
		return
	if tier7_access && !tier7_chosen: 
		get_tree().get_first_node_in_group("bottom ui").talent_alert_toggle(true)
		return
	if tier8_access && !tier8_chosen: 
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
	var tier3_talent
	var tier4_talent
	var tier5_talent
	var tier6_talent
	var tier7_talent
	var tier8_talent
	
	for i in group1.get_buttons():
		if i.button_pressed: tier1_talent = i.get_child(0).talent_scene_path
		tier1_chosen = true
			
	for i in group2.get_buttons():
		if i.button_pressed: tier2_talent =  i.get_child(0).talent_scene_path
		tier2_chosen = true
	
	for i in group3.get_buttons():
		if i.button_pressed: tier3_talent =  i.get_child(0).talent_scene_path
		tier3_chosen = true
	
	for i in group4.get_buttons():
		if i.button_pressed: tier4_talent =  i.get_child(0).talent_scene_path
		tier4_chosen = true
	
	for i in group5.get_buttons():
		if i.button_pressed: tier5_talent =  i.get_child(0).talent_scene_path
		tier5_chosen = true
	
	for i in group6.get_buttons():
		if i.button_pressed: tier6_talent =  i.get_child(0).talent_scene_path
		tier6_chosen = true
	
	for i in group7.get_buttons():
		if i.button_pressed: tier7_talent =  i.get_child(0).talent_scene_path
		tier7_chosen = true
	
	for i in group8.get_buttons():
		if i.button_pressed: tier8_talent =  i.get_child(0).talent_scene_path
		tier8_chosen = true
	
	talent_array.push_back(tier1_talent)
	talent_array.push_back(tier2_talent)
	talent_array.push_back(tier3_talent)
	talent_array.push_back(tier4_talent)
	talent_array.push_back(tier5_talent)
	talent_array.push_back(tier6_talent)
	talent_array.push_back(tier7_talent)
	talent_array.push_back(tier8_talent)
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
	
	counter = 0
	for i in talent_tree_reference.tier3_talents:
		new_talent = load(i).instantiate()
		group3.get_buttons()[counter].add_child(new_talent)
		counter += 1
	for i in group3.get_buttons():
		i.texture_normal = load(i.get_child(0).not_pressed_texture)
		i.texture_hover  = load(i.get_child(0).hover_texture)
		i.texture_pressed = load(i.get_child(0).pressed_texture)
		i.texture_disabled = load(i.get_child(0).disabled_texture)
	
	counter = 0
	for i in talent_tree_reference.tier4_talents:
		new_talent = load(i).instantiate()
		group4.get_buttons()[counter].add_child(new_talent)
		counter += 1
	for i in group4.get_buttons():
		i.texture_normal = load(i.get_child(0).not_pressed_texture)
		i.texture_hover  = load(i.get_child(0).hover_texture)
		i.texture_pressed = load(i.get_child(0).pressed_texture)
		i.texture_disabled = load(i.get_child(0).disabled_texture)
	
	counter = 0
	for i in talent_tree_reference.tier5_talents:
		new_talent = load(i).instantiate()
		group5.get_buttons()[counter].add_child(new_talent)
		counter += 1
	for i in group5.get_buttons():
		i.texture_normal = load(i.get_child(0).not_pressed_texture)
		i.texture_hover  = load(i.get_child(0).hover_texture)
		i.texture_pressed = load(i.get_child(0).pressed_texture)
		i.texture_disabled = load(i.get_child(0).disabled_texture)
	
	counter = 0
	for i in talent_tree_reference.tier6_talents:
		new_talent = load(i).instantiate()
		group6.get_buttons()[counter].add_child(new_talent)
		counter += 1
	for i in group6.get_buttons():
		i.texture_normal = load(i.get_child(0).not_pressed_texture)
		i.texture_hover  = load(i.get_child(0).hover_texture)
		i.texture_pressed = load(i.get_child(0).pressed_texture)
		i.texture_disabled = load(i.get_child(0).disabled_texture)
	
	counter = 0
	for i in talent_tree_reference.tier7_talents:
		new_talent = load(i).instantiate()
		group7.get_buttons()[counter].add_child(new_talent)
		counter += 1
	for i in group7.get_buttons():
		i.texture_normal = load(i.get_child(0).not_pressed_texture)
		i.texture_hover  = load(i.get_child(0).hover_texture)
		i.texture_pressed = load(i.get_child(0).pressed_texture)
		i.texture_disabled = load(i.get_child(0).disabled_texture)
	
	counter = 0
	for i in talent_tree_reference.tier8_talents:
		new_talent = load(i).instantiate()
		group8.get_buttons()[counter].add_child(new_talent)
		counter += 1
	for i in group8.get_buttons():
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
	
	for i in group3.get_buttons():
		for j in Global.player_talent_array:
			if i.get_child(0).talent_scene_path == j:
				i.button_pressed = true
				tier3_chosen = true
	
	for i in group4.get_buttons():
		for j in Global.player_talent_array:
			if i.get_child(0).talent_scene_path == j:
				i.button_pressed = true
				tier4_chosen = true
	
	for i in group5.get_buttons():
		for j in Global.player_talent_array:
			if i.get_child(0).talent_scene_path == j:
				i.button_pressed = true
				tier5_chosen = true
	
	for i in group6.get_buttons():
		for j in Global.player_talent_array:
			if i.get_child(0).talent_scene_path == j:
				i.button_pressed = true
				tier6_chosen = true
	
	for i in group7.get_buttons():
		for j in Global.player_talent_array:
			if i.get_child(0).talent_scene_path == j:
				i.button_pressed = true
				tier7_chosen = true
	
	for i in group8.get_buttons():
		for j in Global.player_talent_array:
			if i.get_child(0).talent_scene_path == j:
				i.button_pressed = true
				tier8_chosen = true

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
		
	if !tier3_access:
		for i in group3.get_buttons():
			i.disabled = true
		$VBoxContainer2/Tier2Block.visible = true
	else:
		for i in group3.get_buttons():
			i.disabled = false
		$VBoxContainer2/Tier2Block.visible = false
	
	if !tier4_access:
		for i in group4.get_buttons():
			i.disabled = true
		$VBoxContainer2/Tier2Block.visible = true
	else:
		for i in group4.get_buttons():
			i.disabled = false
		$VBoxContainer2/Tier2Block.visible = false
	
	if !tier5_access:
		for i in group5.get_buttons():
			i.disabled = true
		$VBoxContainer2/Tier2Block.visible = true
	else:
		for i in group5.get_buttons():
			i.disabled = false
		$VBoxContainer2/Tier2Block.visible = false
	
	if !tier6_access:
		for i in group6.get_buttons():
			i.disabled = true
		$VBoxContainer2/Tier2Block.visible = true
	else:
		for i in group6.get_buttons():
			i.disabled = false
		$VBoxContainer2/Tier2Block.visible = false
	
	if !tier7_access:
		for i in group7.get_buttons():
			i.disabled = true
		$VBoxContainer2/Tier2Block.visible = true
	else:
		for i in group7.get_buttons():
			i.disabled = false
		$VBoxContainer2/Tier2Block.visible = false
	
	if !tier8_access:
		for i in group8.get_buttons():
			i.disabled = true
		$VBoxContainer2/Tier2Block.visible = true
	else:
		for i in group8.get_buttons():
			i.disabled = false
		$VBoxContainer2/Tier2Block.visible = false

func _on_texture_button_mouse_entered():
	pass

func _on_texture_button_mouse_exited():
	pass

func _on_reset_button_button_down():
	reset_talents()

func reset_talents():
	for i in get_tree().get_nodes_in_group("talent_button"):
		i.button_pressed = false
		i.disabled = false
		Global.player_talent_array = []
	
	disable_out_of_reach_talents()
