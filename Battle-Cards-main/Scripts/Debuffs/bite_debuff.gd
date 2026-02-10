extends Node2D

@onready var stats = debuff_stats
@onready var debuff = $BaseDebuff

var debuff_stats: Debuff_Resource = null
var source_stats

func initialize(source):
	source_stats = source.card_stats
	debuff.set_counter(source_stats.debuff_duration)
	
	get_tree().get_first_node_in_group("battle sim").connect("end_of_turn", debuff_effect)
	
	tooltip_effect()
	
func debuff_effect():
	remove_counter()
	stats.owner.take_physical_damage(source_stats.effect1)
	tooltip_effect()

func additional_debuff(source):
	if source.card_stats.effect1 > source_stats.effect1:
		source_stats = source.card_stats
		debuff.set_counter(source_stats.debuff_duration)
		tooltip_effect()
	elif source.card_stats.effect1 == source_stats.effect1:
		source_stats = source.card_stats
		debuff.set_counter(source_stats.debuff_duration)

func remove_counter():
	debuff.change_counter(-1)
	if debuff_stats.count <= 0:
		debuff.remove_debuff()
	tooltip_effect()


func tooltip_effect():
	debuff.update_tooltip(str(stats.name),
	"Effect", 
	"Take " + str(source_stats.effect1) + " damage at the end of each turn", 
	"Effect:")
