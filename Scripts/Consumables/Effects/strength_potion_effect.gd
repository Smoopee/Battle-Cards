extends Node2D


func effect(player):
	print("In strength potion consumable")
	if Global.current_scene != "battle_sim": return false
	player.add_buff(load("res://Scenes/Buffs/strength_potion_buff.tscn").instantiate(), self)
	return true
