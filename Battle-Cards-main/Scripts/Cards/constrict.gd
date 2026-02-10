extends Node2D

@onready var stats = card_stats
@onready var card = $BaseCard

var card_stats: Cards_Resource = null

func effect(player_deck, enemy_deck, player, enemy):
	var damage = stats.dmg
	damage = stats.owner.deal_physical_damage(damage)
	stats.target.take_physical_damage(damage)
	
	var target = stats.target
	var debuff_resource = load("res://Resources/Debuffs/constrict.tres")
	target.add_debuff(debuff_resource, card)

func upgrade_card(num):
	match num:
		1:
			stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade1.png"
			stats.upgrade_level = 1
			stats.dmg = 3
			stats.effect1 = 3
			stats.effect2 = 2
			stats.debuff_duration = 3
			stats.sell_price = 2
			stats.buy_price = 4
		2: 
			stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade2.png"
			stats.upgrade_level = 2
			stats.dmg = 6
			stats.effect1 = 6
			stats.effect2 = 4
			stats.debuff_duration = 3
			stats.sell_price = 4
			stats.buy_price = 8
		3:
			stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade3.png"
			stats.upgrade_level = 3
			stats.dmg = 12
			stats.effect1 = 12
			stats.effect2 = 4
			stats.debuff_duration = 3
			stats.sell_price = 8
			stats.buy_price = 16
		4:
			stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade4.png"
			stats.upgrade_level = 4
			stats.dmg = 24
			stats.effect1 = 12
			stats.effect2 = 8
			stats.debuff_duration = 7
			stats.sell_price = 16
			stats.buy_price = 32
	
	card.update_tooltip(str(stats.name), 
	"Effect", 
	"Deal " + str(stats.dmg) + " damage" +
	"\nDeal an additional " + str(stats.effect1) + " damage at the end of turn for " +
	str(stats.debuff_duration) + " turns." +
	"\nReduce target's speed by " + str(stats.effect2) + " for " + str(stats.debuff_duration) + " turns.", 
	"Effect: ")
	card.upgrade_card_ui()

func item_enchant(enchant):
	pass

func update_card_ui():
	card.update_card_ui()
