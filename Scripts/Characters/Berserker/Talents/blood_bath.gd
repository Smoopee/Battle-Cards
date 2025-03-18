extends Node2D

var talent_name = "Blood Bath"
var tooltip = "WIP"
var talent_scene_path = "res://Scenes/Characters/Berserker/Talents/blood_bath.tscn"

func ready():
	talent_name = "Blood Bath"
	tooltip = "WIP"

func set_talent():
	get_parent().get_parent().blood_bath = true

func talent_effect(source, value):
	if source == null: return value
	if source.is_in_group("character"):
		value += 4
		return value
	else: return value
