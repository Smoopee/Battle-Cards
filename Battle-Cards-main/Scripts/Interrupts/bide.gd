extends Node2D

@onready var stats = interrupt_stats
@onready var interrupt = $BaseInterrupt

var interrupt_stats: Interrupts_Resource = null
var is_toggled = false

var accumulated_dmg = 0


func interrupt_effect(damage):
	accumulated_dmg += get_tree().get_first_node_in_group("character").receiving_physical_dmg
	get_tree().get_first_node_in_group("character").receiving_physical_dmg = 0

func tooltip_effect():
	interrupt.update_tooltip(str(stats.name), 
	"Effect", 
	"Increase Atk by " + str(stats.effect1), 
	"Effect:")

func interrupt_toggled(toggle):
	if toggle:
		get_tree().get_first_node_in_group("character").connect("physical_damage_taken", interrupt_effect)
		get_tree().get_first_node_in_group("battle sim").connect("end_of_turn", de_toggle)
	else:
		get_tree().get_first_node_in_group("character").disconnect("physical_damage_taken", interrupt_effect)
		get_tree().get_first_node_in_group("battle sim").disconnect("end_of_turn", de_toggle)

func de_toggle():
	get_tree().get_first_node_in_group("enemy").take_physical_damage(accumulated_dmg)
	get_child(0).get_node("ImageButton").button_pressed = false
	
