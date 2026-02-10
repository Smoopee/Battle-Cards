extends Node2D


#BUFFS ============================================================================================
func add_buff(buff_resource, source):
	var new_buff = load(buff_resource.buff_scene_path).instantiate()
	new_buff.buff_stats = buff_resource.duplicate()
	new_buff.buff_stats.owner = get_tree().get_first_node_in_group("character")
	
	for i in get_tree().get_nodes_in_group("buff"):
		if (i.buff_stats.name == new_buff.buff_stats.name
		and !i.buff_stats.individual_stacks
		and i.buff_stats.owner == get_tree().get_first_node_in_group("character")): 
			i.get_parent().additional_buff(source)
			return
	
	add_child(new_buff)
	new_buff.initialize(source)
	organize_buffs()

func remove_buff(buff):
	for i in get_children():
		if i == buff:
			remove_child(i)
			i.queue_free()
	organize_buffs()

func organize_buffs():
	var buff_x_position = get_viewport().size.x - 270
	var buff_y_position = get_viewport().size.y - 40

	var x_offset = 0
	for i in get_children():
		i.global_position = Vector2(x_offset + buff_x_position, buff_y_position)
		i.scale = Vector2(1,1)
		x_offset += 50

func buff_reset():
	for i in get_children():
		remove_child(i)
		i.queue_free()
