extends Node2D


@export var card_stats_resource: Cards_Resource

@onready var card_stats 

func _ready():
	set_stats(card_stats_resource)

func set_stats(stats = Cards_Resource) -> void:
	var card_stats_resource: Cards_Resource = preload("res://Resources/Cards/dagger.tres")
	card_stats = card_stats_resource

func on_start(board):
	pass

func effect(player_deck, enemy_deck):
	pass

func upgrade_card(num):
	match num:
		1:
			print("level 1!")
			self.card_stats.card_art_path = "res://Resources/Cards/CardArt/Dagger_card.png"
			self.card_stats.upgrade_level = 1
			self.card_stats.dmg = 3
		2: 
			print("level 2!")
			self.card_stats.card_art_path = "res://Resources/Cards/CardArt/dagger2_card.png"
			self.card_stats.upgrade_level = 2
			self.card_stats.dmg = 6
		3:
			print("level 3!")
			self.card_stats.card_art_path = "res://Resources/Cards/CardArt/dagger3_card.png"
			self.card_stats.upgrade_level = 3
			self.card_stats.dmg = 12

func item_enchantment(enchant):
	pass
