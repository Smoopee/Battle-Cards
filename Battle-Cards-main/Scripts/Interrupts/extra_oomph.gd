extends Node2D

@onready var stats = interrupt_stats
@onready var interrupt = $BaseInterrupt

var interrupt_stats: Interrupts_Resource = null
var is_toggled = false


func interrupt_effect(damage):
	get_tree().get_first_node_in_group("character").dealing_physical_dmg *= 2

func tooltip_effect():
	interrupt.update_tooltip(str(stats.name), 
	"Effect", 
	"Increase Atk by " + str(stats.effect1), 
	"Effect:")

func interrupt_toggled(toggle):
	if get_tree().get_first_node_in_group("character").rage < stats.rage_cost: 
		de_toggle()
		return
	if toggle:
		get_tree().get_first_node_in_group("character").connect("physical_damage_dealt", interrupt_effect)
		get_tree().get_first_node_in_group("battle sim").connect("end_of_turn", de_toggle)
	else:
		get_tree().get_first_node_in_group("character").disconnect("physical_damage_dealt", interrupt_effect)
		get_tree().get_first_node_in_group("battle sim").disconnect("end_of_turn", de_toggle)
		get_tree().get_first_node_in_group("character").change_rage(-stats.rage_cost)

func de_toggle():
	get_child(0).get_node("ImageButton").button_pressed = false
	
