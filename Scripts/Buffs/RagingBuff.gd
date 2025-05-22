extends Node2D

@onready var stats = buff_stats
@onready var buff = $BaseBuff

var buff_stats: Buff_Resource = null
var source_stats

func initialize(source):
	source_stats = stats.owner.rage_attack_increase
	buff.set_counter(source_stats)
	stats.owner.change_attack(source_stats)
	
	tooltip_effect()

func additional_buff(source):
	buff.change_counter(source_stats)
	stats.owner.change_attack(source_stats)

func tooltip_effect():
	buff.update_tooltip(str(stats.name), 
	"Effect", 
	"Increase Atk by " + str(source_stats), 
	"Effect:")
