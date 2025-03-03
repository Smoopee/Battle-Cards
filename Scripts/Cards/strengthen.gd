extends Node2D


@export var card_stats_resource: Cards_Resource

var card_stats: Cards_Resource = null

var rng = RandomNumberGenerator.new()

var upgrade_effect 

func _ready():
	set_stats(card_stats_resource)

func set_stats(stats = Cards_Resource) -> void:
	card_stats = stats

func on_start(board):
	pass

func effect(player_deck, enemy_deck):
	var deck = player_deck
	
	if get_parent().card_resource.in_enemy_deck == true:
		deck = enemy_deck
		
	for i in deck:
		if i.get_child(2).is_in_group("weapon"):
			i.card_resource.dmg += upgrade_effect

func upgrade_card(num):
	match num:
		1:
			print("level 1!")
			get_parent().card_resource.card_art_path= "res://Resources/Cards/CardArt/Strengthen_card.png"
			get_parent().card_resource.upgrade_level = 1
			upgrade_effect = 1
		2: 
			print("level 2!")
			get_parent().card_resource.card_art_path = "res://Resources/Cards/CardArt/strengthen2_card.png"
			get_parent().card_resource.upgrade_level = 2
			upgrade_effect = 2
		3:
			print("level 3!")
			get_parent().card_resource.card_art_path = "res://Resources/Cards/CardArt/strengthen3_card.png"
			get_parent().card_resource.upgrade_level = 3
			upgrade_effect = 3
		4:
			print("level 4!")
			get_parent().card_resource.card_art_path = "res://Resources/Cards/CardArt/strengthen4_card.png"
			get_parent().card_resource.upgrade_level = 4
			upgrade_effect = 4

func item_enchantment(enchant):
	pass
