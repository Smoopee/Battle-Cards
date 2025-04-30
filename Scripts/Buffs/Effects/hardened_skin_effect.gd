extends Node2D

var parent
var stats
var count
var buff_effect


func initialize(source):
	parent = $".."
	stats = parent.buff_stats
	count = source.card_stats.effect2
	buff_effect = source.card_stats.effect1
	
	parent.set_counter(count)
	stats.owner.change_armor(buff_effect)
	
	parent.connect("buff_removed", buff_removed)

func additional_buff(source):
	parent.change_counter(count)

func buff_removed():
	stats.owner.change_armor(-buff_effect)
