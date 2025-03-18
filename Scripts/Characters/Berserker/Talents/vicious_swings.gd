extends Node2D

var talent_name = "Vicious Swings"
var tooltip = "WIP"
var talent_scene_path = "res://Scenes/Characters/Berserker/Talents/vicious_swings.tscn"

func ready():
	talent_name = "Vicious Swings"
	tooltip = "WIP"

func set_talent():
	get_parent().get_parent().vicious_swings = true

func talent_effect(source, value):
	pass
