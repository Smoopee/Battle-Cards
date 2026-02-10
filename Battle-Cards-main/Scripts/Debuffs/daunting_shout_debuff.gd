extends Node2D

@onready var stats = debuff_stats
@onready var debuff = $BaseDebuff

var debuff_stats: Debuff_Resource = null
var source_stats

func initialize(source):
	source_stats = source.card_stats
	debuff.set_counter(source_stats.debuff_duration)
	stats.owner.change_attack(-source_stats.effect1)
	
	get_tree().get_first_node_in_group("battle sim").connect("end_of_round", remove_counter)
	
	tooltip_effect()

func additional_debuff(source):
	if source.card_stats.effect1 > source_stats.effect1:
		source_stats = source.card_stats
		debuff.set_counter(source_stats.debuff_duration)
		stats.owner.change_attack(-source_stats.effect2)
		tooltip_effect()

func remove_counter(round):
	debuff.change_counter(-1)
	if debuff_stats.count <= 0:
		stats.owner.change_attack(source_stats.effect2)
		debuff.remove_debuff()
	tooltip_effect()


func tooltip_effect():
	debuff.update_tooltip(str(stats.name),
	"Effect", 
	"Decreases Atk by " + str(source_stats.effect2) + " for " + 
	str(stats.count) + " rounds.", 
	"Effect:")
