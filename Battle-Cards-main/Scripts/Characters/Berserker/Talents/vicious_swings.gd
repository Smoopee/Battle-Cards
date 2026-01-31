extends Node2D

var talent_name = "Vicious Swings"
var tooltip = "Physical Damage Applies 2 Bleed Damage"
var talent_scene_path = "res://Scenes/Characters/Berserker/Talents/vicious_swings.tscn"

var pressed_texture = "res://Resources/Art/Talents/vicious_swings_pressed.png"
var not_pressed_texture = "res://Resources/Art/Talents/vicious_swings_not_pressed.png"
var hover_texture = "res://Resources/Art/Talents/vicious_swings_hover.png"
var disabled_texture = "res://Resources/Art/Talents/vicious_swings_disabled.png"
var is_selected = false

func ready():
	talent_name = "Vicious Swings"
	tooltip = "WIP"

func talent_signal_connect(scene):
	if scene == "battle_sim":
		talent_setup()

func talent_setup():
	get_tree().get_first_node_in_group("character").connect("physical_damage_dealt", talent_effect)
	
func talent_effect(num):
	get_tree().get_nodes_in_group("character")[0].dealing_physical_dmg += 5
