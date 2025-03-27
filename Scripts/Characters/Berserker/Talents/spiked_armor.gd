extends Node2D

var talent_name = "Spiked Armor"
var tooltip = "WIP"
var talent_scene_path = "res://Scenes/Characters/Berserker/Talents/spiked_armor.tscn"

func ready():
	talent_name = "Spiked Armor"
	tooltip = "WIP"

func set_talent():
	if Global.current_scene == "battle_sim":
		get_tree().get_nodes_in_group("battle sim")[0].connect("physical_damage", talent_effect)

func talent_effect(damage, source):
	var temp = get_tree().get_nodes_in_group("character")[0]
	if source == temp: return
	temp.change_rage(source, 5)
	print("In Spiked armor talent_effect")
