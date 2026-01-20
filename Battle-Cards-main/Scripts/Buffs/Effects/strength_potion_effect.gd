extends Node2D

var parent
var stats
var buff_effect


func initialize(source):
	parent = $".."
	stats = parent.buff_stats
	buff_effect = source.consumable_stats.effect1
	
	parent.set_counter(buff_effect)
	stats.owner.change_attack(buff_effect)
	
	parent.connect("buff_removed", buff_removed)

func additional_buff(source):
	return

func buff_removed():
	stats.owner.change_attack(-buff_effect)
