extends Node2D

var counter = 1
var original_dmg
var gained_dmg
var multiplier

func _ready():
	var parent = get_parent()
	if counter >= 1:
		original_dmg = parent.card_stats.dmg
		parent.card_stats.dmg *= multiplier
		parent.update_card_ui()
		gained_dmg = parent.card_stats.dmg - original_dmg

func remove_counter():
	if counter <= 0: return
	
	counter -= 1
	
	if counter <= 0:
		get_parent().card_stats.dmg -= gained_dmg
		get_parent().update_card_ui()
		queue_free()

