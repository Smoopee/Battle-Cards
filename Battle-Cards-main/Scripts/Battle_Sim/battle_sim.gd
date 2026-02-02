extends Node2D

func _ready():
	get_tree().get_first_node_in_group("bottom ui").toggle_inventory(true)
	get_tree().get_first_node_in_group("player skills").reset_skills()
	$NextTurn.initial_build()
