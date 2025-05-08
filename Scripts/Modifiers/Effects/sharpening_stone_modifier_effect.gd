extends Node2D

@onready var parent = $".."


func _ready():
	get_tree().get_nodes_in_group("battle sim")[0].connect("end_of_round", modifier_decrement)
	parent.connect("modifier_removed", remove_modifier)

func initialize(target):
	target.card_stats.dmg += 5
	target.update_card_ui()
	target.update_tooltip("SharpeningStoneModifier", "Card's Damage increased by " + str(5) + "\n ", "Sharpening Stone: ")
	
func additional_modifier(target):
	print("In additional modifier sharpening stone modifier")
	target.update_tooltip("SharpeningStoneModifier", "Card's Damage increased by " + str(5) + "\n ", "Sharpening Stone: ")

func modifier_decrement(round):
	parent.change_counter(-1)

func remove_modifier(attached_to):
	attached_to.card_stats.dmg -= 5
	queue_free()
