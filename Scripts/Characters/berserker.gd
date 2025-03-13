extends Node2D

@export var character_stats_resource: Character_Resource

var player_stats: Character_Resource = null

# Called when the node enters the scene tree for the first time.
func _ready():
	set_stats(character_stats_resource)
	$TextureProgressBar.position = get_parent().position + Vector2(47, -64)

func set_stats(stats = Character_Resource) -> void:
	player_stats = load("res://Resources/Character/berserker.tres").duplicate()

func change_rage(value):
	$TextureProgressBar.value += value
	if 	$TextureProgressBar.value  >= 100:
		player_stats.attack += 3
		$TextureProgressBar.value = 0
