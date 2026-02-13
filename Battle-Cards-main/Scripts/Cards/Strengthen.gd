extends Node2D

@onready var stats = card_stats
@onready var card = $BaseCard

var card_stats: Cards_Resource = null

func effect(player_deck, enemy_deck, player, enemy):
	var target = stats.owner
	var buff_resource = load('res://Resources/Buffs/strengthen.tres')
	target.add_buff(buff_resource, card)

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
	"Buff Atk by " + str(stats.effect1), 
	"Effect: ")
	card.update_card_ui()
