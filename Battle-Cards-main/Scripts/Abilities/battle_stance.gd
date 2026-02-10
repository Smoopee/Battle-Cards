extends Node2D

@onready var stats = ability_stats
@onready var ability = $BaseAbility

var ability_stats: Abilities_Resource = null
var is_toggled = false

func _ready():
	tooltip_effect()

func ability_effect(damage):
	get_tree().get_first_node_in_group("character").dealing_physical_dmg *= 2

func tooltip_effect():
	ability.update_tooltip(str(stats.name), 
	"Effect", 
	"Increase Atk by " + str(stats.effect1), 
	"Effect:")

func ability_toggled(toggle):
	if toggle:
		get_node("BaseAbility").get_node("AbilityImage").texture = load("res://Resources/Art/Abilities/defensive_stance_ability.png")
	else:
		get_node("BaseAbility").get_node("AbilityImage").texture = load("res://Resources/Art/Abilities/battle_stance_ability.png")
		
func de_toggle():
	print("DETOGGLE")
	get_child(0).get_node("ImageButton").button_pressed = false
	
