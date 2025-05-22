extends Node2D

@onready var stats = consumable_stats
@onready var consumable = $BaseConsumable

var consumable_stats: Consumables_Resource = null

func _ready():
	tooltip_effect()

func effect(card):
	#if Global.current_scene != "battle_sim" or "deck_builder": return false
	if card.card_stats.in_enemy_deck != true: return false
	
	card.get_node("BaseCard").add_modifier(load("res://Scenes/Modifiers/glue_modifier.tscn").instantiate())
	
	return true

func tooltip_effect():
	consumable.update_tooltip(str(stats.name), 
	"Effect", 
	"Put a card on CD for 2 Rounds", 
	"Effect:")
