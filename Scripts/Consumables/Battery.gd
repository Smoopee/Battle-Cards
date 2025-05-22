extends Node2D

@onready var stats = consumable_stats
@onready var consumable = $BaseConsumable

var consumable_stats: Consumables_Resource = null

func _ready():
	tooltip_effect()

func effect(card):
	print("In battery consumable")
	if Global.current_scene != "battle_sim": return false
	if card.card_stats.cd_remaining <= 0: return false
	card.get_node("BaseCard").change_cd_remaining(-2)
	return true

func tooltip_effect():
	consumable.update_tooltip(str(stats.name), 
	"Effect", 
	"Reduce a card's remaining CD by 2", 
	"Effect:")
