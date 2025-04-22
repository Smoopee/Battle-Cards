extends Node2D


var modifier_name = "Sharpening Stone"
var attached_to



func modifier_initializer(target):
	attached_to = target
	attached_to.card_stats.dmg += 5
	attached_to.update_card_ui()


func remove_modifier():
	attached_to.card_stats.dmg -= 5
	attached_to.update_card_ui()

