extends Node2D

@onready var stats = debuff_stats
@onready var debuff = $BaseDebuff

var debuff_stats: Debuff_Resource = null
var source_stats

func initialize(source):
	source_stats = source.card_stats
	debuff.set_counter(source_stats.debuff_duration)
	stats.owner.change_speed(-source_stats.effect2)
	
	get_tree().get_first_node_in_group("battle sim").connect("end_of_turn", debuff_effect)
	
	tooltip_effect()
	
func debuff_effect():
	remove_counter()
	stats.owner.take_physical_damage(source_stats.effect1)
	tooltip_effect()

func additional_debuff(source):
	pass
	#if source.card_stats.effect1 > source_stats.effect1:
		#source_stats = source.card_stats
		#debuff.set_counter(source_stats.effect1)
		#stats.owner.change_attack(-source_stats.effect2)
		#tooltip_effect()

func remove_counter():
	debuff.change_counter(-1)
	if debuff_stats.count <= 0:
		stats.owner.change_speed(source_stats.effect2)
		debuff.remove_debuff()
	tooltip_effect()


func tooltip_effect():
	debuff.update_tooltip(str(stats.name),
	"Effect", 
	"Decreases Speed by " + str(source_stats.effect2) + " for " + 
	str(stats.count) + " rounds. \n" +
	"Take " + str(source_stats.effect1) + " damage at the end of each turn", 
	"Effect:")
