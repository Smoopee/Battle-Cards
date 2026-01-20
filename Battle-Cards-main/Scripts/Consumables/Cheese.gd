extends Node2D

@onready var stats = consumable_stats
@onready var consumable = $BaseConsumable

var consumable_stats: Consumables_Resource = null

func _ready():
	tooltip_effect()

func effect(player):
	print("In cheese consumable")
	if Global.current_scene != "battle_sim": return false
	var buff_resource = load('res://Resources/Buffs/cheese.tres')
	player.add_buff(buff_resource, self)
	return true

func tooltip_effect():
	consumable.update_tooltip(str(stats.name), 
	"Effect", 
	"Increase Atk by " + str(stats.effect1), 
	"Effect:")

