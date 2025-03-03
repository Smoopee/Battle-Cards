extends Node2D


@export var card_stats_resource: Cards_Resource

var card_stats: Cards_Resource = null

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
			get_parent().card_resource.card_art_path = "res://Resources/Cards/CardArt/health_potion_card.png"
			get_parent().card_resource.upgrade_level = 1
			get_parent().card_resource.heal = 3
		2: 
			print("level 2!")
			get_parent().card_resource.card_art_path = "res://Resources/Cards/CardArt/health_potion2_card.png"
			get_parent().card_resource.upgrade_level = 2
			get_parent().card_resource.heal = 6
		3:
			print("level 3!")
			get_parent().card_resource.card_art_path = "res://Resources/Cards/CardArt/health_potion3_card.png"
			get_parent().card_resource.upgrade_level = 3
			get_parent().card_resource.heal = 12
		4:
			print("level 4!")
			get_parent().card_resource.card_art_path = "res://Resources/Cards/CardArt/health_potion4_card.png"
			get_parent().card_resource.upgrade_level = 4
			get_parent().card_resource.heal = 24
			

func item_enchantment(enchant):
	pass
