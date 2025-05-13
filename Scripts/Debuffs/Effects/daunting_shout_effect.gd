extends Node2D

@onready var parent = $".."

var stats
var count 
var debuff_effect

func initialize(source):
	stats = parent.debuff_stats
	count = source.card_stats.effect1
	debuff_effect = -source.card_stats.effect2
	
	parent.set_counter(count)
	stats.owner.change_attack(debuff_effect)
	tooltip_effect()

func additional_debuff(source):
	stats = parent.debuff_stats
	count = source.card_stats.effect1
	debuff_effect = source.card_stats.effect2
	
	parent.change_counter(count)

func tooltip_effect():
	stats = parent.debuff_stats
	parent.update_tooltip(str(stats.name), 
	"Effect", 
	"Decrease Attack by " + str(debuff_effect) + 
	"\nfor " + str(count) + " rounds",
	"Effect:")
