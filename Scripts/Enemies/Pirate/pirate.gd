extends Node2D

@export var enemy_stats_resource: Enemy_Resource

@onready var enemy_deck = $Deck.enemy_deck

var enemy_stats: Enemy_Resource = null

var enemy_scene_path = "res://Scenes/Enemies/pirate.tscn"

func _ready():
	set_stats(enemy_stats_resource)

func set_stats(stats = Enemy_Resource) -> void:
	enemy_stats = stats
