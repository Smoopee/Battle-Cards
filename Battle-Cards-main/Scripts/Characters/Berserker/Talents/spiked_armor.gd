extends Node2D

var talent_name = "Spiked Armor"
var tooltip = "Deal 10 Reflect Damage"
var talent_scene_path = "res://Scenes/Characters/Berserker/Talents/spiked_armor.tscn"

var pressed_texture  = "res://Resources/Art/Talents/spiked_armor_pressed.png"
var not_pressed_texture = "res://Resources/Art/Talents/spiked_armor_not_pressed.png"
var hover_texture = "res://Resources/Art/Talents/spiked_armor_hover.png"
var disabled_texture = "res://Resources/Art/Talents/spiked_armor_disabled.png"
var is_selected = false

func ready():
	talent_name = "Spiked Armor"
	tooltip = "WIP"

func talent_signal_connect(scene):
	if scene == "battle_sim":
		talent_setup()

func talent_setup():
	get_tree().get_first_node_in_group("character").connect("physical_damage_taken", talent_effect)
	
func talent_effect(num):
	get_tree().get_first_node_in_group("enemy").take_physical_damage(10)
