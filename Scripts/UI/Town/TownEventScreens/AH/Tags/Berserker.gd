extends Node2D


func effect():
	get_tree().get_first_node_in_group("card manager").setup_ah("Berserker")

