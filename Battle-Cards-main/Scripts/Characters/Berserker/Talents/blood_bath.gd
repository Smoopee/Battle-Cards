extends Node2D

var talent_name = "Blood Bath"
var tooltip = "Heal for half of the bleeding damage you deal"
var talent_scene_path = "res://Scenes/Characters/Berserker/Talents/blood_bath.tscn"

var pressed_texture  = "res://Resources/Art/Talents/blood_bath_pressed.png"
var not_pressed_texture = "res://Resources/Art/Talents/blood_bath_not_pressed.png"
var hover_texture = "res://Resources/Art/Talents/blood_bath_hover.png"
var disabled_texture = "res://Resources/Art/Talents/blood_bath_disabled.png"
var is_selected = false

func ready():
	talent_name = "Blood Bath"
	tooltip = "WIP"

func talent_signal_connect(scene):
	if scene == "battle_sim":
		talent_setup()

func talent_setup():
	get_tree().get_first_node_in_group("character").connect("physical_damage_dealt", talent_effect)
	
func talent_effect(num):
	get_tree().get_nodes_in_group("character")[0].heal(10)
