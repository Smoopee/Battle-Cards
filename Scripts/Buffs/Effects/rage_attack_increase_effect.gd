extends Node2D


func initialize(source):
	var parent = $".."
	var stats = parent.buff_stats
	var buff_effect = stats.owner.rage_attack_increase
	
	parent.set_counter(buff_effect)
	stats.owner.change_attack(buff_effect)

func additional_buff(source):
	var parent = $".."
	var stats = parent.buff_stats
	var buff_effect = stats.owner.rage_attack_increase
	
	parent.change_counter(buff_effect)
	stats.owner.change_attack(buff_effect)
