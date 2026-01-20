extends Node2D


func initialize(source):
	var parent = $".."
	var stats = parent.buff_stats
	var buff_effect1 = source.card_stats.effect1
	var buff_effect2 = source.card_stats.effect2
	
	parent.set_counter(buff_effect2)
	
	stats.owner.change_attack(-buff_effect1)
	stats.owner.change_defense(buff_effect2)

func additional_buff(source):
	print("In additional buff defensive stance")
