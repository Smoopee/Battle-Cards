extends Node2D


func initialize(source):
	var parent = $".."
	var stats = parent.buff_stats
	var buff_effect = source.consumable_stats.effect1
	print("Buff effect in cheese is " + str(source.consumable_stats))
	print("Buff effect in cheese is " + str(source.consumable_stats.consumable_name))
	
	parent.set_counter(buff_effect)
	stats.owner.change_attack(buff_effect)

func additional_buff(source):
	print("In additional buff cheese")
