extends Node2D

@onready var stats = card_stats
@onready var card = $BaseCard

var card_stats: Cards_Resource = null

func effect(player_deck, enemy_deck, player, enemy):
	var target = stats.owner
	var buff_resource = load("res://Resources/Buffs/seethe.tres")
	target.add_buff(buff_resource, card)
	

func upgrade_card(num):
	match num:
		1:
			stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade1.png"
			stats.upgrade_level = 1
			stats.effect1 = 10
			stats.sell_price = 2
			stats.buy_price = 4
		2: 
			stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade2.png"
			stats.upgrade_level = 2
			stats.effect1 = 15
			stats.sell_price = 4
			stats.buy_price = 8
		3:
			stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade3.png"
			stats.upgrade_level = 3
			stats.effect1 = 25
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
	"Gain " + str(stats.effect1) + " rage " +
	"every turn for " + str(stats.buff_duration) + " turns.", 
	"Effect: ")
	card.upgrade_card_ui()

func item_enchant(enchant):
	match enchant:
		"Bleed":
			stats.item_enchant = "Bleed"
			stats.bleed_dmg = 8
			stats.sell_price *= 2
			stats.buy_price *= 2
			card.update_tooltip("Enchantment", "Bleed", "Deal " + str(stats.bleed_dmg) + " bleed damage",  "Bleed: ")
		"Exhaust":
			stats.item_enchant = "Exhaust"
			card.update_tooltip("Enchantment", "Exhaust", "Put Opposing card on CD for 1 Round",  "Exhaust: ")
		"Dejavu":
			stats.item_enchant = "Dejavu"
			card.update_tooltip("Enchantment", "Dejavu", "Repeat Card Effects",  "Dejavu: ")
		"Fiery":
			stats.item_enchant = "Fiery"
			stats.burn_dmg = 4
			stats.sell_price *= 2
			stats.buy_price *= 2
			card.update_tooltip("Enchantment", "Fiery", "Deal " + str(stats.burn_dmg) + " fire damage"  + "\n ",  "Fiery: ")
		"Lifesteal":
			stats.item_enchant = "Lifesteal"
			card.update_tooltip("Enchantment", "Lifesteal", "Heal for " + str(stats.dmg) + " damage",  "Lifesteal: ")
		"Rapid":
			stats.item_enchant = "Rapid"
			card.update_tooltip("Enchantment", "Rapid", "Reduce and random card's CD by 1",  "Rapid: ")
		"Restoration":
			stats.item_enchant = "Restoration"
			stats.heal = 10
			stats.sell_price *= 2
			stats.buy_price *= 2
			card.update_tooltip("Enchantment", "Restoration", "Heal for " + str(stats.heal),  "Restoration: ")
		"Toxic":
			stats.item_enchant = "Toxic"
			stats.poison_dmg = 2
			stats.sell_price *= 2
			stats.buy_price *= 2
			card.update_tooltip("Enchantment", "Poison", "Deal " + str(stats.poison_dmg) + " poison damage",  "Poison: ")
		"Prosperity":
			stats.item_enchant = "Prosperity"
			stats.prosperity += 5
			card.update_tooltip("Enchantment", "Prosperity", "Gain " + str(stats.prosperity) + " Gold",  "Prosperity: ")
	card.update_card_ui()

func update_card_ui():
	card.update_card_ui()
