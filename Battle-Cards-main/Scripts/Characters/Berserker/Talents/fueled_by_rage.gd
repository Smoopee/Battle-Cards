extends Node2D

var talent_name = "Fueled by Rage"
var tooltip = "Attack from gaining rage is increased by 5"
var talent_scene_path = "res://Scenes/Characters/Berserker/Talents/fueled_by_rage.tscn"

var pressed_texture  = "res://Resources/Art/Talents/fueled_by_rage_pressed.png"
var not_pressed_texture = "res://Resources/Art/Talents/fueled_by_rage_not_pressed.png"
var hover_texture = "res://Resources/Art/Talents/fueled_by_rage_hover.png"
var disabled_texture = "res://Resources/Art/Talents/fueled_by_rage_disabled.png"
var is_selected = false

func ready():
	talent_name = "Fuled by Rage"
	tooltip = "WIP"

func talent_signal_connect(scene):
	if scene == "battle_sim":
		talent_setup()

func talent_setup():
	talent_effect()
	
func talent_effect(num = 0):
	get_tree().get_nodes_in_group("character")[0].rage_attack_increase += 5
