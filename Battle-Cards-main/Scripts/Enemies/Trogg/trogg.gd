extends Node2D

@onready var stats = character_stats
@onready var character = $BaseEnemy


var character_stats: Enemy_Resource = null
var enemy_deck 

func _ready():
	tooltip_enemy()
	character.set_stats()
	character.set_deck()
	character.set_skills()
	character.set_stat_container()
	character.set_enemy_gold()
	character.set_enemy_xp()
	
	enemy_deck_function()

func enemy_deck_function():
	enemy_deck = [
		"Rock",
		"Rock",
		"Rock",
		"Rock",
		"Rock",
		"Strengthen",
		"Daunting Shout"
	]
	
	return enemy_deck
func tooltip_enemy():
	character.update_tooltip(str(character_stats.name), 
	"Flavor Text", 
	"Likes to smash", 
	"")
