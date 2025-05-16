extends Node2D

var talent_name = "Indomitable"
var tooltip = "Rage gained from damage taken is increased by 5"
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
		get_tree().get_nodes_in_group("character")[0].connect("physical_damage_taken", talent_effect)

func talent_effect(damage):
	get_tree().get_nodes_in_group("character")[0].change_rage(5)
	print("In Indomitable talent_effect")
