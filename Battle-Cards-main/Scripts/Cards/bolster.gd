extends Node2D

@onready var stats = card_stats
@onready var card = $BaseCard

var card_stats: Cards_Resource = null

func effect(player_deck, enemy_deck, player, enemy):
	var target_deck = enemy_deck
	if stats.owner == player: target_deck = player_deck
	
	var modifier_resource = load("res://Resources/Modifiers/bolster.tres")
	
	for i in target_deck:
		if (i.stats.deck_position == stats.deck_position + 1 or 
		i.stats.deck_position == stats.deck_position - 1):
			i.get_node("BaseCard").add_modifier(modifier_resource, card)

func upgrade_card(num):
	match num:
		1:
			stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade1.png"
			stats.upgrade_level = 1
			stats.effect1 = 5
			stats.sell_price = 2
			stats.buy_price = 4
		2: 
			stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade2.png"
			stats.upgrade_level = 2
			stats.effect1 = 10
			stats.sell_price = 4
			stats.buy_price = 8
		3:
			stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade3.png"
			stats.upgrade_level = 3
			stats.effect1 = 20
			stats.sell_price = 8
			stats.buy_price = 16
		4:
			stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade4.png"
			stats.upgrade_level = 4
			stats.effect1 = 40
			stats.sell_price = 16
			stats.buy_price = 32
	
	card.update_tooltip(str(stats.name), 
	"Effect", 
	"Increase the damage of Attack cards next to this card
	\nby " + str(stats.effect1) +
	" for " + str(stats.buff_duration) + " rounds.", 
	"Effect: ")
	card.upgrade_card_ui()

func item_enchant(enchant):
	pass
