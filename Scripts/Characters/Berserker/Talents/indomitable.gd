extends Node2D

var talent_name = "Indomitable"
var tooltip = "WIP"
var talent_scene_path = "res://Scenes/Characters/Berserker/Talents/indomitable.tscn"
var pressed_texture  = "res://Resources/Art/Talents/indomitable_pressed.png"
var not_pressed_texture = "res://Resources/Art/Talents/indomitable_not_pressed.png"
var hover_texture = "res://Resources/Art/Talents/indomitable_hover.png"
var disabled_texture = "res://Resources/Art/Talents/indomitable_disabled.png"

func ready():
	talent_name = "Indomitable"
	tooltip = "WIP"

func set_talent():
	if Global.current_scene == "battle_sim":
		get_tree().get_nodes_in_group("battle sim")[0].connect("physical_damage", talent_effect)

func talent_effect(card, source, damage):
	var temp = get_tree().get_nodes_in_group("character")[0]
	if source == temp: return
	temp.change_rage(source, 5)
	print("In Indomitable talent_effect")
