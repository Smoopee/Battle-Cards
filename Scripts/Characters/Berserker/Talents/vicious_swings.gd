extends Node2D

var talent_name = "Vicious Swings"
var tooltip = "WIP"
var talent_scene_path = "res://Scenes/Characters/Berserker/Talents/vicious_swings.tscn"
var pressed_texture = "res://Resources/Art/Talents/vicious_swings_pressed.png"
var not_pressed_texture = "res://Resources/Art/Talents/vicious_swings_not_pressed.png"
var hover_texture = "res://Resources/Art/Talents/vicious_swings_hover.png"
var disabled_texture = "res://Resources/Art/Talents/vicious_swings_disabled.png"

func ready():
	talent_name = "Vicious Swings"
	tooltip = "WIP"

func set_talent():
	if Global.current_scene == "battle_sim":
		get_tree().get_nodes_in_group("battle sim")[0].connect("physical_damage", talent_effect)

func talent_effect(source, target, damage, card):
	var temp = get_tree().get_nodes_in_group("character")[0]
	if source != temp: return
	var enemy = get_tree().get_nodes_in_group("enemy")[0]
	get_tree().get_nodes_in_group("battle sim")[0].add_bleed_damage(enemy, 2)
