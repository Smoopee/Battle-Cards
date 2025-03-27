extends Node2D

var talent_name = "Blood Bath"
var tooltip = "WIP"
var talent_scene_path = "res://Scenes/Characters/Berserker/Talents/blood_bath.tscn"

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
