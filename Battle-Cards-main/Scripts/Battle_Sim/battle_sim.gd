extends Node2D

func _ready():
	get_tree().get_first_node_in_group("bottom ui").toggle_character(true)
	$NextTurn.initial_build()
