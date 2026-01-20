extends Node2D

var talent_name = "Savagery"
var tooltip = "Rage from damage increased by 5"
var talent_scene_path = "res://Scenes/Characters/Berserker/Talents/savagery.tscn"

var pressed_texture  = "res://Resources/Art/Talents/savagery_pressed.png"
var not_pressed_texture = "res://Resources/Art/Talents/savagery_not_pressed.png"
var hover_texture = "res://Resources/Art/Talents/savagery_hover.png"
var disabled_texture = "res://Resources/Art/Talents/savagery_disabled.png"

func ready():
	talent_name = "Savagery"
	tooltip = "Rage from damage increased by 5"

func set_talent():
	if Global.current_scene == "battle_sim":
		get_tree().get_nodes_in_group("character")[0].connect("physical_damage_dealt", talent_effect)
	
func talent_effect(damage):
	get_tree().get_nodes_in_group("character")[0].change_rage(5)
	print("In savagery talent_effect")
