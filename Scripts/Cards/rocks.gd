extends Node2D

@export var card_stats_resource: Cards_Resource

var card_stats: Cards_Resource = null

var rng = RandomNumberGenerator.new()

func _ready():
	set_stats(card_stats_resource)

func set_stats(stats = Cards_Resource) -> void:
	card_stats = stats 

func on_start(board):
	pass

func effect(player_deck, enemy_deck):
	pass

func upgrade_card(num):
	match num:
		1:
			print("level 1!")
			get_parent().card_resource.card_art_path = "res://Resources/Cards/CardArt/Rock_card.png"
			get_parent().card_resource.upgrade_level = 1
			get_parent().card_resource.dmg = 2
			get_parent().card_resource.sell_price = 1
			get_parent().card_resource.buy_price = 2
		2: 
			print("level 2!")
			get_parent().card_resource.card_art_path = "res://Resources/Cards/CardArt/rock2_card.png"
			get_parent().card_resource.upgrade_level = 2
			get_parent().card_resource.dmg = 4
			get_parent().card_resource.sell_price = 2
			get_parent().card_resource.buy_price = 4
		3:
			print("level 3!")
			get_parent().card_resource.card_art_path = "res://Resources/Cards/CardArt/rock3_card.png"
			get_parent().card_resource.upgrade_level = 3
			get_parent().card_resource.dmg = 8 
			get_parent().card_resource.sell_price = 4
			get_parent().card_resource.buy_price = 8
		4:
			print("level 4!")
			get_parent().card_resource.card_art_path = "res://Resources/Cards/CardArt/rock4_card.png"
			get_parent().card_resource.upgrade_level = 4
			get_parent().card_resource.dmg = 16
			get_parent().card_resource.sell_price = 8
			get_parent().card_resource.buy_price = 16

func item_enchant(enchant):
	match enchant:
		"Bleed":
			get_parent().card_resource.item_enchant = "Bleed"
			get_parent().card_resource.bleed_dmg = 6
			get_parent().card_resource.sell_price *= 2
			get_parent().card_resource.buy_price *= 2
			print("Bleeding for " + str(get_parent().card_resource.bleed_dmg))
