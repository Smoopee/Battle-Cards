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
	var buff = preload("res://Scenes/Buffs/double_up_buff.tscn")
	var card_position = self.card_stats.position
	var new_instance = buff.instantiate()
	var switch = false
	
	while switch == false:
		if self.card_stats.in_enemy_deck == true:
			if enemy_deck[card_position].is_in_group("weapon"):
				enemy_deck[card_position].add_child(new_instance)
				switch = true
			else:
				card_position += 1
		else:
			if player_deck[card_position].is_in_group("weapon"):
				player_deck[card_position].add_child(new_instance)
				switch = true
			else:
				card_position += 1

func item_level(num):
	pass

func item_enchantment(enchant):
	pass
