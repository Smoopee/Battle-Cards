extends Node2D

@onready var parent = $".."


func _ready():
	pass

func initialize(target):
	target.card_stats.dmg += 5
	target.update_card_ui()
	target.update_tooltip("Modifier", "SharpeningStoneModifier", "Card's Damage increased by " + str(5) + "\n ", "Sharpening Stone: ")
	
func additional_modifier(target):
	print("In additional modifier sharpening stone modifier")
	

func modifier_decrement(round):
	parent.change_counter(-1)

func remove_modifier(attached_to):
	print("In remove sharpening stone modifier")
	attached_to.card_stats.dmg -= 5
	queue_free()
