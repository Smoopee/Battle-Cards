extends Node2D

signal hoovered
signal hoovered_off

var hand_position
var card_slotted = false
var card_name = ""
var path = ""
var is_players = false

# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().connect_card_signals(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_mouse_entered():
	emit_signal("hoovered", self)


func _on_area_2d_mouse_exited():
	emit_signal("hoovered_off", self)
