extends Node2D

@onready var stats = buff_stats
@onready var buff = $BaseBuff

var buff_stats: Buff_Resource = null
var source_stats
var count


func initialize(source):
	source_stats = source.card_stats
	buff.set_counter(source_stats.buff_duration)
	stats.owner.change_defense(source_stats.effect1)
	
	get_tree().get_first_node_in_group("battle sim").connect("end_of_round", remove_counter)
	tooltip_effect()
	

func additional_buff(source):
	if source.card_stats.effect1 > source_stats.effect1:
		source_stats = source.card_stats
		buff.set_counter(source_stats.buff_duration)
		stats.owner.change_defense(source_stats.effect1 - source.card_stats.effect1)
		tooltip_effect()

func remove_counter(round):
	buff.change_counter(-1)
	if buff_stats.count <= 0:
		stats.owner.change_defense(-source_stats.effect1)
		buff.remove_buff()
	tooltip_effect()


func tooltip_effect():
	buff.update_tooltip(str(stats.name), 
	"Effect", 
	"Increase Defense by " + str(source_stats.effect1) + 
	"\nfor " + str(stats.count) + " rounds",
	"Effect:")
