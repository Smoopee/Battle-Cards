extends Node2D

@onready var parent = $".."

func tooltip_merchant():
	var stats = parent.merchant_stats
	parent.update_tooltip(str(stats.merchant_name), 
	"Flavor Text", 
	"Sells Enchantments", 
	"")
