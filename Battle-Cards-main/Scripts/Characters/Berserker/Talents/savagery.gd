extends Node2D

var talent_name = "Savagery"
var tooltip = "Add 3 Damage to Attacks"
var talent_scene_path = "res://Scenes/Characters/Berserker/Talents/savagery.tscn"

var pressed_texture  = "res://Resources/Art/Talents/savagery_pressed.png"
var not_pressed_texture = "res://Resources/Art/Talents/savagery_not_pressed.png"
var hover_texture = "res://Resources/Art/Talents/savagery_hover.png"
var disabled_texture = "res://Resources/Art/Talents/savagery_disabled.png"
var is_selected = false

func ready():
	talent_name = "Vicious Swings"
	tooltip = "Rage from damage increased by 10"

func talent_signal_connect(scene):
	if scene == "battle_sim":
		talent_setup()

func talent_setup():
	get_tree().get_first_node_in_group("character").connect("physical_damage_dealt", talent_effect)
	
func talent_effect(num):
	get_tree().get_nodes_in_group("character")[0].change_rage(10)
