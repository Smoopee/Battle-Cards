extends Node2D

@export var card_stats_resource: Cards_Resource

var card_stats: Cards_Resource = null

var rng = RandomNumberGenerator.new()

func _ready():
	set_stats(card_stats_resource)

func set_stats(stats = Cards_Resource) -> void:
	card_stats = stats 

func upgrade_card():
	pass
