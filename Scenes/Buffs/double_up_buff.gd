extends Node2D

var counter = 1
var original_dmg
var gained_dmg
var multiplier

func _ready():
	var parent = get_parent().get_parent()
	if counter >= 1:
		if get_parent().is_in_group("weapon"):
			original_dmg = parent.card_resource.dmg
			parent.card_resource.dmg *= multiplier
			gained_dmg = parent.card_resource.dmg - original_dmg
	
	
func remove_counter():
	if counter <= 0: return
	var parent = get_parent().get_parent()
	
	counter -= 1
	
	if counter <= 0:
		if get_parent().is_in_group("weapon"):
			
			parent.card_resource.dmg -= gained_dmg
		self.queue_free()

