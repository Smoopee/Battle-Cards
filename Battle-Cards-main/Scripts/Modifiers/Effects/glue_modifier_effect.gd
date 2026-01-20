extends Node2D

@onready var parent = $".."


func _ready():
	get_tree().get_nodes_in_group("battle sim")[0].connect("end_of_round", modifier_decrement)
	parent.connect("modifier_removed", remove_modifier)

func initialize(target):
	target.change_cd(2)
	target.change_cd_remaining(2)
	parent.count = 2
	
func additional_modifier(target):
	print("In additional modifier glue modifier")

func modifier_decrement(round):
	parent.change_counter(-1)

func remove_modifier(attached_to):
	attached_to.change_cd(-2)
	attached_to.change_cd_remaining(-2)
	queue_free()
