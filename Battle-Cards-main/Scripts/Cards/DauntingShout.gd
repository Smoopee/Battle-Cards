extends Node2D

@onready var stats = card_stats
@onready var card = $BaseCard

var card_stats: Cards_Resource = null

func effect(player_deck, enemy_deck, player, enemy):
	var target = stats.target

	var debuff_resource = load("res://Resources/Debuffs/daunting_shout.tres")
	target.add_debuff(debuff_resource, card)

func upgrade_card(num):
	match num:
		1:
			stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade1.png"
			stats.upgrade_level = 1
			stats.sell_price = 3
			stats.buy_price = 6
			stats.effect1 = 2
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
	
	card.update_tooltip(str(stats.name),
	"Effect", 
	"Decrease Enemy's Atk by " + str(stats.effect2) + " for " + str(stats.effect1) + " rounds", 
	"Effect: ")
	card.update_card_ui()

func item_enchant(enchant):
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
	card.update_card_ui()
