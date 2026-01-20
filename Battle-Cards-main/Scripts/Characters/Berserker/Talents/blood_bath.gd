extends Node2D

var talent_name = "Blood Bath"
var tooltip = "Heal for half of the bleeding damage you deal"
var talent_scene_path = "res://Scenes/Characters/Berserker/Talents/blood_bath.tscn"
var pressed_texture  = "res://Resources/Art/Talents/blood_bath_pressed.png"
var not_pressed_texture = "res://Resources/Art/Talents/blood_bath_not_pressed.png"
var hover_texture = "res://Resources/Art/Talents/blood_bath_hover.png"
var disabled_texture = "res://Resources/Art/Talents/blood_bath_disabled.png"

func ready():
	talent_name = "Blood Bath"
	tooltip = "WIP"

func set_talent():
	if Global.current_scene == "battle_sim":
		get_tree().get_nodes_in_group("battle sim")[0].connect("bleed_damage", talent_effect)

func talent_effect(source, value):
	var temp = get_tree().get_nodes_in_group("character")[0]
	if source == temp: return
	get_tree().get_first_node_in_group("battle sim").more_healing(temp, value/2)
	print("In Blood_bath talent_effect")
