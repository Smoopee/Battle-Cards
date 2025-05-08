extends Node2D

@onready var parent = $".."

func effect(player_deck, enemy_deck, player, enemy):
	var stats = parent.card_stats
	var target = stats.owner

	var buff_resource = load('res://Resources/Buffs/hardened_skin.tres')
	target.add_buff(buff_resource, parent)

func upgrade_card(num):
	var stats = parent.card_stats
	match num:
		1:
			stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade1.png"
			stats.upgrade_level = 1
			stats.sell_price = 3
			stats.buy_price = 6
			stats.effect1 = 1
		2: 
			stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade2.png"
			stats.upgrade_level = 2
			stats.sell_price = 6
			stats.buy_price = 12
			stats.effect1 = 4
		3:
			stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade3.png"
			stats.upgrade_level = 3
			stats.sell_price = 12
			stats.buy_price = 24
			stats.effect1 = 8
		4:
			stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade4.png"
			stats.upgrade_level = 4
			stats.sell_price = 48
			stats.buy_price = 96
			stats.effect1 = 16
	
	parent.update_tooltip("Effect", "Increase Armor by " + str(stats.effect1) + 
	" for " + str(stats.effect2) + " rounds", "Effect: ")
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
