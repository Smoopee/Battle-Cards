extends Node2D

signal hoovered
signal hoovered_off

var hand_position
var card_slotted = false
var card_name = ""
var path = ""
var is_players = false
var card_position
var card_resource

func _ready():
	var card_manager = (get_tree().get_nodes_in_group("card manager")[0])
	card_manager.connect_card_signals(self)

func _on_area_2d_mouse_entered():
	emit_signal("hoovered", self)


func _on_area_2d_mouse_exited():
	emit_signal("hoovered_off", self)
