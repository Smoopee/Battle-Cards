extends Node2D

@onready var stats = modifier_stats
@onready var modifier = $BaseModifier

var modifier_stats: Modifier_Resource = null
var source_stats

var total_dmg_increase = 0

func _ready():
	pass
	#parent.connect("modifier_removed", remove_modifier)

func initialize(source):
	source_stats = source.card_stats
	total_dmg_increase += source_stats.effect1
	stats.attached_to.card_stats.temp_dmg += source_stats.effect1
	modifier.set_counter(source_stats.effect1)
	stats.attached_to.update_card_ui()
	#target.update_tooltip("Modifier", "SwarmModifier", "Card's Damage increased by " + str(total_dmg_increase) + "\n ", "Swarm: ")
	tooltip_effect(stats.attached_to)
	
func additional_modifier(source):
	source_stats = source.card_stats
	total_dmg_increase += source_stats.effect1
	stats.attached_to.card_stats.temp_dmg += source_stats.effect1
	modifier.change_counter(source_stats.effect1)
	stats.attached_to.update_card_ui()
	#target.update_tooltip("Modifier", "SwarmModifier", "Card's Damage increased by " + str(total_dmg_increase) + "\n ", "Swarm: ")
	tooltip_effect(stats.attached_to)


func tooltip_effect(target):
	target.update_tooltip(str(stats.name), 
	"Modifier", 
	"Card's Damage increased by " + str(total_dmg_increase) + "\n ",
	"Modifier:")
