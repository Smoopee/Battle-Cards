extends Node2D

var talent_name = "Vicious Swings"
var tooltip = "WIP"
var talent_scene_path = "res://Scenes/Characters/Berserker/Talents/vicious_swings.tscn"

func ready():
	talent_name = "Vicious Swings"
	tooltip = "WIP"

func set_talent():
	if Global.current_scene == "battle_sim":
		get_tree().get_nodes_in_group("battle sim")[0].connect("physical_damage", talent_effect)

func talent_effect(value, source):
	var temp = get_tree().get_nodes_in_group("character")[0]
	if source != temp: return
	var enemy = get_tree().get_nodes_in_group("enemy")[0]
	get_tree().get_nodes_in_group("battle sim")[0].add_bleed_damage(enemy, 2)
	
