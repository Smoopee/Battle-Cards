extends Node2D

var talent_name = "Fuled by Rage"
var tooltip = "Attack from gaining rage is increased by 5"
var talent_scene_path = "res://Scenes/Characters/Berserker/Talents/fueled_by_rage.tscn"
var pressed_texture  = "res://Resources/Art/Talents/fueled_by_rage_pressed.png"
var not_pressed_texture = "res://Resources/Art/Talents/fueled_by_rage_not_pressed.png"
var hover_texture = "res://Resources/Art/Talents/fueled_by_rage_hover.png"
var disabled_texture = "res://Resources/Art/Talents/fueled_by_rage_disabled.png"

func ready():
	talent_name = "Fuled by Rage"
	tooltip = "WIP"

func set_talent():
	get_tree().get_nodes_in_group("character")[0].rage_attack_increase += 5
	print("In fueled by rage")

