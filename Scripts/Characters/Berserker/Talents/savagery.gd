extends Node2D

var talent_name = "Savagery"
var tooltip = "Rage from damage increased by 2"
var talent_scene_path = "res://Scenes/Characters/Berserker/Talents/savagery.tscn"

func ready():
	talent_name = "Savagery"
	tooltip = "Rage from damage increased by 2"

func set_talent():
	get_parent().get_parent().savagery = true
	
func talent_effect(source, value):
	if source == null: return value
	if source.is_in_group("character"):
		value += 4
		return value
	else: return value
