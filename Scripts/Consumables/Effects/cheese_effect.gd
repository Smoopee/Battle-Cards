extends Node2D

func effect(player):
	print("In cheese consumable")
	if Global.current_scene != "battle_sim": return false
	var buff_resource = load('res://Resources/Buffs/cheese.tres')
	player.add_buff(buff_resource, $"..")
	return true
