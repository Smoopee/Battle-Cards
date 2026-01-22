extends Node2D

const BUFF_X_POSITION = -625
const BUFF_Y_POSITION = -130


#BUFFS ============================================================================================
func add_buff(buff_resource, source):
	var new_buff = load(buff_resource.buff_scene_path).instantiate()
	new_buff.buff_stats = buff_resource.duplicate()
	new_buff.buff_stats.owner = get_tree().get_first_node_in_group("enemy")
	
	for i in get_tree().get_nodes_in_group("buff"):
		if (i.buff_stats.name == new_buff.buff_stats.name 
		and i.buff_stats.owner == get_tree().get_first_node_in_group("enemy")): 
			i.get_parent().additional_buff(source)
			return
	
	add_child(new_buff)
	new_buff.initialize(source)
	organize_buffs()

func remove_buff(buff):
	for i in get_children():
		if i.buff_stats.name == buff:
			i.queue_free()
	organize_buffs()

func organize_buffs():
	var x_offset = 0
	for i in get_children():
		i.position = position + Vector2(x_offset + BUFF_X_POSITION, BUFF_Y_POSITION)
		i.scale = Vector2(1,1)
		x_offset += 50
