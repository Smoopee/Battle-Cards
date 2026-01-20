extends Node2D

@onready var parent = $".."

var stats
var count
var buff_effect


func initialize(source):
	stats = parent.buff_stats
	count = source.card_stats.effect2
	buff_effect = source.card_stats.effect1
	
	parent.set_counter(count)
	stats.owner.change_armor(buff_effect)
	tooltip_effect()
	
	parent.connect("buff_removed", buff_removed)

func additional_buff(source):
	parent.change_counter(count)

func buff_removed():
	stats.owner.change_armor(-buff_effect)

func tooltip_effect():
	var stats = parent.buff_stats
	parent.update_tooltip(str(stats.name), 
	"Effect", 
	"Increase Armor by " + str(buff_effect) + 
	"\nfor " + str(count) + " rounds",
	"Effect:")
