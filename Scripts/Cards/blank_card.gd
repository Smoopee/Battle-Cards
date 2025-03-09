extends Node2D

@export var card_stats_resource: Cards_Resource

@onready var card_stats 

func _ready():
	set_stats(card_stats_resource)

func set_stats(stats = Cards_Resource) -> void:
	var card_stats_resource: Cards_Resource = preload("res://Resources/Cards/blank.tres")
	card_stats = card_stats_resource

func on_start(board):
	pass

func effect(player_deck, enemy_deck, player, enemy):
	pass

func upgrade_card(num):
	pass

func item_enchant(enchant):
	pass

func update_card_ui():
	pass
