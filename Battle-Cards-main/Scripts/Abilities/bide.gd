extends Node2D

@onready var stats = ability_stats
@onready var ability = $BaseAbility

var ability_stats: Abilities_Resource = null
var is_toggled = false

var accumulated_dmg = 0


func ability_effect(damage):
	accumulated_dmg += get_tree().get_first_node_in_group("character").receiving_physical_dmg
	get_tree().get_first_node_in_group("character").receiving_physical_dmg = 0

func tooltip_effect():
	ability.update_tooltip(str(stats.name), 
	"Effect", 
	"Increase Atk by " + str(stats.effect1), 
	"Effect:")

func ability_toggled(toggle):
	if get_tree().get_first_node_in_group("character").character_stats.rage < stats.cost: 
		de_toggle()
		return
	if toggle:
		get_tree().get_first_node_in_group("character").connect("physical_damage_taken", ability_effect)
		get_tree().get_first_node_in_group("battle sim").connect("end_of_turn", de_toggle)
	else:
		get_tree().get_first_node_in_group("character").disconnect("physical_damage_taken", ability_effect)
		get_tree().get_first_node_in_group("battle sim").disconnect("end_of_turn", de_toggle)

func de_toggle():
	get_tree().get_first_node_in_group("enemy").take_physical_damage(accumulated_dmg)
	get_child(0).get_node("ImageButton").button_pressed = false
	
