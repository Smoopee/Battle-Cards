extends Node2D


var modifier_name = "Exhaust"
var attached_to
var count = 0


func _ready():
	get_tree().get_nodes_in_group("battle sim")[0].connect("end_of_round", modifier_decrement)

func modifier_initializer(target):
	attached_to = target
	attached_to.change_cd(1)
	attached_to.change_cd_remaining(1)
	count = 2

func modifier_decrement(round):
	count -= 1
	if count <= 0:
		remove_modifier()

func remove_modifier():
	attached_to.change_cd(-1)
	attached_to.change_cd_remaining(-1)
	queue_free()
