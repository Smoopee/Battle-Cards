extends Node2D


@export var card_stats_resource: Cards_Resource

var card_stats: Cards_Resource = null

var upgrade_effect

func _ready():
	set_stats(card_stats_resource)

func set_stats(stats = Cards_Resource) -> void:
	card_stats = stats

func on_start(board):
	pass

func effect(player_deck, enemy_deck):
	var buff = preload("res://Scenes/Buffs/double_up_buff.tscn")
	var card_position = get_parent().card_resource.hand_position
	var new_instance = buff.instantiate()
	new_instance.multiplier = upgrade_effect
	var switch = false
	
	while switch == false:
		if get_parent().card_resource.in_enemy_deck == true:
			if enemy_deck[card_position].get_child(Global.card_node_reference).is_in_group("weapon"):
				enemy_deck[card_position].get_child(Global.card_node_reference).add_child(new_instance)
				switch = true
			else:
				card_position += 1
		else:
			if player_deck[card_position].get_child(Global.card_node_reference).is_in_group("weapon"):
				player_deck[card_position].get_child(Global.card_node_reference).add_child(new_instance)
				switch = true
			else:
				card_position += 1

func upgrade_card(num):
	match num:
		1:
			print("level 1!")
			get_parent().card_resource.card_art_path= "res://Resources/Cards/CardArt/double_up_card.png"
			get_parent().card_resource.upgrade_level = 1
			get_parent().card_resource.sell_price = 3
			get_parent().card_resource.buy_price = 6
			upgrade_effect = 2
		2: 
			print("level 2!")
			get_parent().card_resource.card_art_path = "res://Resources/Cards/CardArt/double_up2_card.png"
			get_parent().card_resource.upgrade_level = 2
			get_parent().card_resource.sell_price = 6
			get_parent().card_resource.buy_price = 12
			upgrade_effect = 2.5
		3:
			print("level 3!")
			get_parent().card_resource.card_art_path = "res://Resources/Cards/CardArt/double_up3_card.png"
			get_parent().card_resource.upgrade_level = 3
			get_parent().card_resource.sell_price = 12
			get_parent().card_resource.buy_price = 24
			upgrade_effect = 3
		4:
			print("level 4!")
			get_parent().card_resource.card_art_path = "res://Resources/Cards/CardArt/double_up4_card.png"
			get_parent().card_resource.upgrade_level = 4
			get_parent().card_resource.sell_price = 24
			get_parent().card_resource.buy_price = 48
			upgrade_effect = 3.5


func item_enchant(enchant):
	pass
