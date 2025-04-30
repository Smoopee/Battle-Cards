extends Node2D


func initialize(source):
	var parent = $".."
	var stats = parent.debuff_stats
	var count = source.card_stats.effect1
	var debuff_effect = -source.card_stats.effect2
	
	parent.set_counter(count)
	stats.owner.change_attack(debuff_effect)

func additional_debuff(source):
	var parent = $".."
	var stats = parent.debuff_stats
	var count = source.card_stats.effect1
	var debuff_effect = source.card_stats.effect2
	
	parent.change_counter(count)

