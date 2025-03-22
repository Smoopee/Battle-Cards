extends Control

var count = 0
var debuff_name = "Bleed"

func debuff_counter(amount):
	count += amount
	$DebuffCounters.text = str(count)

func debuff_decrement(amount = 1):
	count -= 1
	$DebuffCounters.text = str(count)
