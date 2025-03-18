extends Node2D

var talent_name = "Indomitable"
var tooltip = "WIP"
var talent_scene_path = "res://Scenes/Characters/Berserker/Talents/indomitable.tscn"

func ready():
	talent_name = "Indomitable"
	tooltip = "WIP"

func set_talent():
	get_parent().get_parent().indomitable = true

func talent_effect(source, value):
	print("In indomitable")
	if source == null: return value
	if source.is_in_group("enemy"):
		value += 4
		return value
	else: return value
