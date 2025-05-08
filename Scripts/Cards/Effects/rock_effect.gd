extends Node2D

@onready var parent = $".."

func effect(player_deck, enemy_deck, player, enemy):
	var stats = parent.card_stats
	var damage = stats.dmg
	damage = stats.owner.deal_physical_damage(damage)
	stats.target.take_physical_damage(damage)
	
	if stats.bleed_dmg > 0:
		stats.target.apply_bleeding_damage(stats.bleed_dmg)

func upgrade_card(num):
	var stats = parent.card_stats
	match num:
		1:
			stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade1.png"
			stats.upgrade_level = 1
			stats.dmg = 2
			stats.sell_price = 1
			stats.buy_price = 2
		2: 
			stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade2.png"
			stats.upgrade_level = 2
			stats.dmg = 4
			stats.sell_price = 2
			stats.buy_price = 4
		3:
			stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade3.png"
			stats.upgrade_level = 3
			stats.dmg = 8 
			stats.sell_price = 4
			stats.buy_price = 8
		4:
			stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade4.png"
			stats.upgrade_level = 4
			stats.dmg = 16
			stats.sell_price = 8
			stats.buy_price = 16
			
	parent.update_tooltip("Effect", "Deal " + str(stats.dmg) + " damage", "Effect: ")
	parent.update_card_ui()

func item_enchant(enchant):
	var stats = parent.card_stats
	match enchant:
		"Bleed":
			stats.item_enchant = "Bleed"
			stats.bleed_dmg = 6
			stats.sell_price *= 2
			stats.buy_price *= 2
		"Exhaust":
			stats.item_enchant = "Exhaust"
		"Dejavu":
			stats.item_enchant = "Dejavu"
		"Fiery":
			stats.item_enchant = "Fiery"
		"Lifesteal":
			stats.item_enchant = "Lifesteal"
		"Rapid":
			stats.item_enchant = "Rapid"
		"Restoration":
			stats.item_enchant = "Restoration"
		"Toxic":
			stats.item_enchant = "Toxic"
	parent.update_card_ui()
