extends Node2D

var talent_name = "Fuled by Rage"
var tooltip = "WIP"
var talent_scene_path = "res://Scenes/Characters/Berserker/Talents/fueled_by_rage.tscn"

func ready():
	talent_name = "Fuled by Rage"
	tooltip = "WIP"

func set_talent():
	get_parent().get_parent().fueled_by_rage = true
	print("In fueled by rage")
	
func talent_effect(source, value):
	pass
