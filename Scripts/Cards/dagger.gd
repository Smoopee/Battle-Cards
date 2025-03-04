extends Node2D

@export var card_stats_resource: Cards_Resource

@onready var card_stats 

func _ready():
	set_stats(card_stats_resource)

func set_stats(stats = Cards_Resource) -> void:
	var  card_stats_resource: Cards_Resource = preload("res://Resources/Cards/dagger.tres")
	card_stats = card_stats_resource

func on_start(board):
	pass

func effect(player_deck, enemy_deck):
	pass

func upgrade_card(num):
	match num:
		1:
			print("level 1!")
			get_parent().card_resource.card_art_path= "res://Resources/Cards/CardArt/Dagger_card.png"
			get_parent().card_resource.upgrade_level = 1
			get_parent().card_resource.dmg = 3
		2: 
			print("level 2!")
			get_parent().card_resource.card_art_path = "res://Resources/Cards/CardArt/dagger2_card.png"
			get_parent().card_resource.upgrade_level = 2
			get_parent().card_resource.dmg = 6
		3:
			print("level 3!")
			get_parent().card_resource.card_art_path = "res://Resources/Cards/CardArt/dagger3_card.png"
			get_parent().card_resource.upgrade_level = 3
			get_parent().card_resource.dmg = 12
		4:
			print("level 4!")
			get_parent().card_resource.card_art_path = "res://Resources/Cards/CardArt/dagger3_card.png"
			get_parent().card_resource.upgrade_level = 4
			get_parent().card_resource.dmg = 24
			

func item_enchant(enchant):
	pass
