extends Node2D

@onready var parent = $".."
var total_dmg_increase = 0


func _ready():
	parent.connect("modifier_removed", remove_modifier)

func initialize(target):
	total_dmg_increase += 1
	target.card_stats.dmg += 1
	target.update_card_ui()
	target.update_tooltip("Modifier", "SwarmModifier", "Card's Damage increased by " + str(total_dmg_increase) + "\n ", "Swarm: ")
	
func additional_modifier(target):
	total_dmg_increase += 1
	target.card_stats.dmg += 1
	target.update_card_ui()
	target.update_tooltip("Modifier", "SwarmModifier", "Card's Damage increased by " + str(total_dmg_increase) + "\n ", "Swarm: ")

func modifier_decrement(round):
	parent.change_counter(-1)

func remove_modifier(attached_to):
	attached_to.card_stats.dmg -= total_dmg_increase
	queue_free()
