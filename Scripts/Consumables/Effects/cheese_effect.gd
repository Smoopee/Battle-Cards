extends Node2D

@onready var parent = $".."


func effect(player):
	print("In cheese consumable")
	if Global.current_scene != "battle_sim": return false
	var buff_resource = load('res://Resources/Buffs/cheese.tres')
	player.add_buff(buff_resource, $"..")
	return true

func tooltip_effect():
	var stats = parent.consumable_stats
	parent.update_tooltip(str(stats.name), 
	"Effect", 
	"Increase Atk by " + str(stats.effect1), 
	"Effect:")

