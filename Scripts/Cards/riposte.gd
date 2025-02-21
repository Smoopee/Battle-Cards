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
	var owned = true
	var current_pos = self.card_stats.position
	if self.card_stats.in_enemy_deck == true: owned = false
	
	if owned:
		enemy_deck[current_pos - 1].card_stats.dmg -= 3
		print("You riposte their " + str(enemy_deck[current_pos - 1].card_stats.name) + "!")
	else:
		player_deck[current_pos - 1].card_stats.dmg -= 3
		print("They riposte your " + str(player_deck[current_pos - 1].card_stats.name) + "!")

func item_level(num):
	pass

func item_enchantment(enchant):
	pass
