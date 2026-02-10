extends Node2D


@onready var stats = character_stats
@onready var character = $BaseEnemy

var enemy_deck
var character_stats: Enemy_Resource = null

func _ready():
	tooltip_enemy()
	character.set_stats()
	character.set_deck()
	character.set_stat_container()
	character.set_runes()
	character.set_enemy_gold()
	character.set_enemy_xp()

func enemy_deck_function():
	enemy_deck = [
		"Swarm",
		"Swarm",
		"Swarm",
		"Swarm",
		"Swarm",
		"Swarm",
		"Swarm"
	]
	return enemy_deck

func tooltip_enemy():
	character.update_tooltip(str(character_stats.name), 
	"Flavor Text", 
	"Rats, A lot of Rats", 
	"")
