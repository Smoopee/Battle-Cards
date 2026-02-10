extends Node2D


#BUFFS ============================================================================================
func add_debuff(debuff_resource, source):
	var new_debuff = load(debuff_resource.debuff_scene_path).instantiate()
	new_debuff.debuff_stats = debuff_resource.duplicate()
	new_debuff.debuff_stats.owner = get_tree().get_first_node_in_group("character")
	
	for i in get_tree().get_nodes_in_group("debuff"):
		if (i.debuff_stats.name == new_debuff.debuff_stats.name
		and !i.debuff_stats.individual_stacks
		and i.debuff_stats.owner == get_tree().get_first_node_in_group("character")): 
			i.get_parent().additional_debuff(source)
			return
	
	add_child(new_debuff)
	new_debuff.initialize(source)
	organize_debuffs()

func remove_debuff(debuff):
	for i in get_children():
		if i == debuff:
			remove_child(i)
			i.queue_free()
	organize_debuffs()

func organize_debuffs():
	var buff_x_position = 270
	var buff_y_position = get_viewport().size.y - 40

	var x_offset = 0
	for i in get_children():
		i.global_position = Vector2(x_offset + buff_x_position, buff_y_position)
		i.scale = Vector2(1,1)
		x_offset -= 50

func debuff_reset():
	for i in get_children():
		remove_child(i)
		i.queue_free()
