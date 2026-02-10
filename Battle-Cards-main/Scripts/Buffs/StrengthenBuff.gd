extends Node2D

@onready var stats = buff_stats
@onready var buff = $BaseBuff

var buff_stats: Buff_Resource = null
var source_stats

func initialize(source):
	source_stats = source.card_stats
	buff.set_counter(source_stats.effect1)
	stats.owner.change_attack(source_stats.effect1)
	
	tooltip_effect()

func additional_buff(source):
	source_stats = source.card_stats
	buff.change_counter(source_stats.effect1)
	stats.owner.change_attack(source_stats.effect1)
	
	tooltip_effect()

func tooltip_effect():
	buff.update_tooltip(str(stats.name), 
	"Effect", 
	"Increase Atk by " + str(stats.count), 
	"Effect:")
