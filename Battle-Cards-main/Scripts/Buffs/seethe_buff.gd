extends Node2D

@onready var stats = buff_stats
@onready var buff = $BaseBuff

var buff_stats: Buff_Resource = null
var source_stats

func initialize(source):
	source_stats = source.card_stats
	buff.set_counter(source_stats.buff_duration)
	get_tree().get_first_node_in_group("battle sim").connect("end_of_turn", buff_effect)
	tooltip_effect()

func buff_effect():
	remove_counter()
	stats.owner.change_rage(source_stats.effect1)
	tooltip_effect()
	
func remove_counter():
	buff.change_counter(-1)
	if buff_stats.count <= 0:
		buff.remove_buff()


func additional_buff(source):
	source_stats = source.card_stats
	buff.change_counter(source_stats.buff_duration)
	stats.owner.change_rage(source_stats.effect1)
	
	tooltip_effect()

func tooltip_effect():
	buff.update_tooltip(str(stats.name), 
	"Effect", 
	"Gain " + str(source_stats.effect1) + " at the end of your turn.", 
	"Effect:")
