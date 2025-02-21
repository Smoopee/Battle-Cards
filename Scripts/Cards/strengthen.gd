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
	var deck = player_deck
	
	if self.card_stats.in_enemy_deck == true:
		deck = enemy_deck
		
	print("Strength activated!")
	for i in deck:
		if i.is_in_group("weapon"):
			i.card_stats.dmg += 1

func item_level(num):
	pass

func item_enchantment(enchant):
	pass
