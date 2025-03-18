extends Node2D

var talent_name = "Tempered Forgings"
var tooltip = "WIP"
var talent_scene_path = "res://Scenes/Characters/Berserker/Talents/tempered_forgings.tscn"

func ready():
	talent_name = "Tempered Forgings"
	tooltip = "WIP"

func talent_effect(source, value):
	if source == null: return value
	if source.is_in_group("character"):
		value += 4
		return value
	else: return value
