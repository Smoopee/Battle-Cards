extends Node2D

@onready var stats = card_stats
@onready var card = $BaseCard

var card_stats: Cards_Resource = null
var is_transformed = false

func effect(player_deck, enemy_deck, player, enemy):
	if !is_transformed:
		card.card_image.texture = load("res://Resources/Art/Cards/fireball_card.png").duplicate()
		stats = load("res://Resources/Cards/fireball.tres").duplicate()
		stats.owner = card_stats.owner
		stats.target = card_stats.target
		is_transformed = true
		upgrade_card(card_stats.upgrade_level)
	else: effect2(player_deck, enemy_deck, player, enemy)

func effect2(player_deck, enemy_deck, player, enemy):
	var damage = stats.dmg
	damage = stats.owner.deal_physical_damage(damage)
	stats.target.take_physical_damage(damage)
	
	if is_transformed:
		card.card_image.texture = load("res://Resources/Art/Cards/incantation_fireball_card.png").duplicate()
		stats = load("res://Resources/Cards/incantation_fireball.tres").duplicate()
		stats.owner = card_stats.owner
		stats.target = card_stats.target
		is_transformed = false
		upgrade_card(card_stats.upgrade_level)

	
func upgrade_card(num):
	if !is_transformed:
		match num:
			1:
				stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade1.png"
				stats.upgrade_level = 1
				stats.sell_price = 2
				stats.buy_price = 4
			2: 
				stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade2.png"
				stats.upgrade_level = 2
				stats.sell_price = 4
				stats.buy_price = 8
			3:
				stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade3.png"
				stats.upgrade_level = 3
				stats.sell_price = 8
				stats.buy_price = 16
			4:
				stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade4.png"
				stats.upgrade_level = 4
				stats.sell_price = 16
				stats.buy_price = 32
		
		card.update_tooltip(str(stats.name), 
		"Effect", 
		"Transform into Fireball next turn", 
		"Effect: ")
		card.upgrade_card_ui()
	
	elif is_transformed:
		match num:
			1:
				stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade1.png"
				stats.upgrade_level = 1
				stats.dmg = 10
				stats.sell_price = 2
				stats.buy_price = 4
			2: 
				stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade2.png"
				stats.upgrade_level = 2
				stats.dmg = 20
				stats.sell_price = 4
				stats.buy_price = 8
			3:
				stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade3.png"
				stats.upgrade_level = 3
				stats.dmg = 40
				stats.sell_price = 8
				stats.buy_price = 16
			4:
				stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade4.png"
				stats.upgrade_level = 4
				stats.dmg = 80
				stats.sell_price = 16
				stats.buy_price = 32
		
		card.update_tooltip(str(stats.name), 
		"Effect", 
		"Deal " + str(stats.dmg) + " damage", 
		"Effect: ")
		card.upgrade_card_ui()

func item_enchant(enchant):
	pass

func update_card_ui():
	card.update_card_ui()
