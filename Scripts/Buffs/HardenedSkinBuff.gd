extends Node2D

@onready var stats = buff_stats
@onready var buff = $BaseBuff

var buff_stats: Buff_Resource = null
var source_stats
var count


func initialize(source):
	source_stats = source.card_stats
	count = source_stats.effect2
	buff.set_counter(count)
	stats.owner.change_armor(source_stats.effect1)
	tooltip_effect()
	
	buff.connect("buff_removed", buff_removed)

func additional_buff(source):
	buff.change_counter(count)

func buff_removed():
	stats.owner.change_armor(-source_stats.effect1)

func tooltip_effect():
	buff.update_tooltip(str(stats.name), 
	"Effect", 
	"Increase Armor by " + str(source_stats.effect1) + 
	"\nfor " + str(count) + " rounds",
	"Effect:")
