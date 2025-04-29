extends Node2D


func initialize(source):
	var parent = $".."
	var stats = parent.buff_stats
	var buff_effect = 50
	
	parent.set_counter(buff_effect)
	stats.owner.change_attack(buff_effect)
