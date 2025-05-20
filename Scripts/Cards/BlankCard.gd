extends Node2D

@onready var stats = card_stats
@onready var card = $BaseCard

var card_stats: Cards_Resource = null

func effect(player_deck, enemy_deck, player, enemy):
	return

func upgrade_card(num):
	match num:
		1:
			stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade1.png"
			stats.upgrade_level = 1
		2: 
			stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade2.png"
			stats.upgrade_level = 2
		3:
			stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade3.png"
			stats.upgrade_level = 3
		4:
			stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade4.png"
			stats.upgrade_level = 4

	card.update_tooltip(str(stats.name), "Effect", "Buff Atk by " + str(stats.effect1), "Effect: ")
	card.update_card_ui()

func item_enchant(enchant):
	match enchant:
		"Bleed":
			stats.item_enchant = "Bleed"
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

func update_card_ui():
	card.update_card_ui()
