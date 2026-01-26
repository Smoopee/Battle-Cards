extends Node2D

@onready var stats = card_stats
@onready var card = $BaseCard

var card_stats: Cards_Resource = null

func effect(player_deck, enemy_deck, player, enemy):
	var target = player
	if card_stats.in_enemy_deck == true:
		target = enemy
		enemy.character_stats.block += card_stats.effect1
	else:
		player.character_stats.block += card_stats.effect1
		player.change_block()

func upgrade_card(num):
	match num:
		1:
			card_stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade1.png"
			card_stats.upgrade_level = 1
			card_stats.sell_price = 3
			card_stats.buy_price = 6
			card_stats.effect1 = 10
		2: 
			card_stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade2.png"
			card_stats.upgrade_level = 2
			card_stats.sell_price = 6
			card_stats.buy_price = 12
			card_stats.effect1 = 20
			card_stats.cd = 1
		3:
			card_stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade3.png"
			card_stats.upgrade_level = 3
			card_stats.sell_price = 12
			card_stats.buy_price = 24
			card_stats.effect1 = 40
			card_stats.cd = 0
		4:
			card_stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade4.png"
			card_stats.upgrade_level = 4
			card_stats.sell_price = 48
			card_stats.buy_price = 96
			card_stats.effect1 = 50
			card_stats.buff_count = 2
	
	card.update_tooltip("Effect", "Block the next " + str(card_stats.effect1) + " physical damage")
	card.update_card_ui()

func item_enchant(enchant):
	match enchant:
		"Bleed":
			card_stats.item_enchant = "Bleed"
			card_stats.bleed_dmg = 8
			card_stats.sell_price *= 2
			card_stats.buy_price *= 2
		"Exhaust":
			card_stats.item_enchant = "Exhaust"
		"Dejavu":
			card_stats.item_enchant = "Dejavu"
		"Fiery":
			card_stats.item_enchant = "Fiery"
		"Lifesteal":
			card_stats.item_enchant = "Lifesteal"
		"Rapid":
			card_stats.item_enchant = "Rapid"
		"Restoration":
			card_stats.item_enchant = "Restoration"
		"Toxic":
			card_stats.item_enchant = "Toxic"
	card.update_card_ui()
