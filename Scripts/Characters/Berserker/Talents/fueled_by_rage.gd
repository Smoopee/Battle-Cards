extends Node2D

var talent_name = "Fuled by Rage"
var tooltip = "WIP"
var talent_scene_path = "res://Scenes/Characters/Berserker/Talents/fueled_by_rage.tscn"

func ready():
	talent_name = "Fuled by Rage"
	tooltip = "WIP"

func set_talent():
	get_tree().get_nodes_in_group("character")[0].rage_attack_increase += 5
	print("In fueled by rage")

