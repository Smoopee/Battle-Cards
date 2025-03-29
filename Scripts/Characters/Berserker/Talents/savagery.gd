extends Node2D

var talent_name = "Savagery"
var tooltip = "Rage from damage increased by 5"
var talent_scene_path = "res://Scenes/Characters/Berserker/Talents/savagery.tscn"

func ready():
	talent_name = "Savagery"
	tooltip = "Rage from damage increased by 5"

func set_talent():
	if Global.current_scene == "battle_sim":
		get_tree().get_nodes_in_group("battle sim")[0].connect("physical_damage", talent_effect)
	
func talent_effect(card, source, damage):
	var temp = get_tree().get_nodes_in_group("character")[0]
	if source != temp: return
	temp.change_rage(source, 5)
	print("In savagery talent_effect")
