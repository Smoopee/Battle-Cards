extends Node2D

var talent_name = "Indomitable"
var tooltip = "Rage gained from damage taken is increased by 30"
var talent_scene_path = "res://Scenes/Characters/Berserker/Talents/indomitable.tscn"

var pressed_texture  = "res://Resources/Art/Talents/indomitable_pressed.png"
var not_pressed_texture = "res://Resources/Art/Talents/indomitable_not_pressed.png"
var hover_texture = "res://Resources/Art/Talents/indomitable_hover.png"
var disabled_texture = "res://Resources/Art/Talents/indomitable_disabled.png"
var is_selected = false

func ready():
	talent_name = "Indomitable"
	tooltip = "WIP"

func talent_signal_connect(scene):
	if scene == "battle_sim":
		talent_setup()

func talent_setup():
	get_tree().get_first_node_in_group("character").connect("physical_damage_taken", talent_effect)
	
func talent_effect(num):
	get_tree().get_nodes_in_group("character")[0].change_rage(30)
