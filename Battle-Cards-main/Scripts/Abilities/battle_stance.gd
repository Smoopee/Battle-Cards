extends Node2D

@onready var stats = ability_stats
@onready var ability = $BaseAbility

var ability_stats: Abilities_Resource = null
var is_active = false
var battle_stance = true

func set_ability():
	tooltip_effect()

func toggle_battle_stance():
	get_tree().get_first_node_in_group("character").change_attack(ability_stats.effect1)
	if is_active:
		get_tree().get_first_node_in_group("character").change_defense(-ability_stats.effect2)
	is_active = true
	battle_stance = true
	tooltip_effect()
		
func toggle_defensive_stance():
	get_tree().get_first_node_in_group("character").change_defense(ability_stats.effect2)
	if is_active:
		get_tree().get_first_node_in_group("character").change_attack(-ability_stats.effect1)
	is_active = true
	battle_stance = false
	tooltip_effect()
		
func tooltip_effect():
	if battle_stance:
		ability.update_tooltip(str(stats.name), 
		"Effect", 
		"Increase Atk by " + str(stats.effect1), 
		"Effect:")
	else:
		ability.update_tooltip(str("Defensive Stance"), 
		"Effect", 
		"Increase Defense by " + str(stats.effect2), 
		"Effect:")

func ability_toggled(toggle):
	if !toggle:
		get_node("BaseAbility").get_node("AbilityImage").texture = load("res://Resources/Art/Abilities/defensive_stance_ability.png")
		toggle_defensive_stance()
	else:
		get_node("BaseAbility").get_node("AbilityImage").texture = load("res://Resources/Art/Abilities/battle_stance_ability.png")
		toggle_battle_stance()
