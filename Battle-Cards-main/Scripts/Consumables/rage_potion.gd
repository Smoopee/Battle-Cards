extends Node2D

@onready var stats = consumable_stats
@onready var consumable = $BaseConsumable

var consumable_stats: Consumables_Resource = null

func _ready():
	tooltip_effect()

func effect(player):
	if Global.current_scene != "battle_sim": return false
	player.change_rage(100)
	return true

func tooltip_effect():
	consumable.update_tooltip(str(stats.name), 
	"Effect", 
	"Increase Atk by " + str(stats.effect1), 
	"Effect:")
