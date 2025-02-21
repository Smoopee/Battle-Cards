extends Node2D

var counter = 1
var original_dmg
var gained_dmg

func _ready():
	print("double_up_buff: counter is " + str(counter))
	var parent = get_parent()
	if counter >= 1:
		if parent.is_in_group("weapon"):
			original_dmg = parent.card_stats.dmg
			parent.card_stats.dmg *= 2
			gained_dmg = parent.card_stats.dmg - original_dmg

	
	
func remove_counter():
	print("remove_counter")
	if counter <= 0: return
	var parent = get_parent()
	
	counter -= 1
	
	if counter <= 0:
		if parent.is_in_group("weapon"):
			parent.card_stats.dmg -= gained_dmg
		self.queue_free()

