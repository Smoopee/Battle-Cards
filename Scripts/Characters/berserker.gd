extends Node2D

@export var character_stats_resource: Character_Resource

var player_stats: Character_Resource = null

# Called when the node enters the scene tree for the first time.
func _ready():
	set_stats(character_stats_resource)

func set_stats(stats = Character_Resource) -> void:
	player_stats = load("res://Resources/Character/berserker.tres").duplicate()
