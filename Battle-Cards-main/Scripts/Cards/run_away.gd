extends Node2D

@onready var stats = card_stats
@onready var card = $BaseCard

var card_stats: Cards_Resource = null

func effect(player_deck, enemy_deck, player, enemy):
	card_stats.owner.connect("physical_damage_taken", card_effect)

func card_effect(damage):
	card_stats.owner.receiving_physical_dmg = 0
	get_tree().get_first_node_in_group("battle sim").connect("start_of_turn", remove_effect)

func remove_effect():
	card_stats.owner.disconnect("physical_damage_taken", card_effect)
	get_tree().get_first_node_in_group("battle sim").disconnect("start_of_turn", remove_effect)

func upgrade_card(num):
	match num:
		1:
			stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade1.png"
			stats.upgrade_level = 1
			stats.cd = 3
			stats.base_cd = 3
			stats.sell_price = 2
			stats.buy_price = 4
		2: 
			stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade2.png"
			stats.upgrade_level = 2
			stats.cd = 2
			stats.base_cd = 2
			stats.sell_price = 4
			stats.buy_price = 8
		3:
			stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade3.png"
			stats.upgrade_level = 3
			stats.cd = 1
			stats.base_cd = 1
			stats.sell_price = 8
			stats.buy_price = 16
		4:
			stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade4.png"
			stats.upgrade_level = 4
			stats.cd = 0
			stats.base_cd = 0
			stats.sell_price = 16
			stats.buy_price = 32
			
	
	card.update_tooltip(str(stats.name), 
	"Effect", 
	"Cannot be damaged until next turn.", 
	"Effect: ")
	card.upgrade_card_ui()

func item_enchant(enchant):
	pass

func update_card_ui():
	card.update_card_ui()
