extends Node2D


func initialize(source):
	var parent = $".."
	var stats = parent.buff_stats
	var buff_effect = source.card_stats.effect1
	
	parent.set_counter(buff_effect)
	stats.owner.change_attack(buff_effect)

func additional_buff(source):
	var parent = $".."
	var stats = parent.buff_stats
	var buff_effect = source.card_stats.effect1
	
	parent.change_counter(buff_effect)
	stats.owner.change_attack(buff_effect)

func tooltip_effect():
	return
