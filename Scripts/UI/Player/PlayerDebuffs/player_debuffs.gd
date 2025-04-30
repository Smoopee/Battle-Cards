extends Node2D

const DEBUFF_X_POSITION = 625
const DEBUFF_Y_POSITION = 130


#BUFFS ============================================================================================
func add_debuff(debuff_resource, source):
	var new_debuff = load(debuff_resource.debuff_scene_path).instantiate()
	new_debuff.debuff_stats = debuff_resource
	new_debuff.debuff_stats.owner = get_tree().get_first_node_in_group("character")
	
	for i in get_tree().get_nodes_in_group("debuff"):
		if (i.debuff_stats.debuff_name == new_debuff.debuff_stats.debuff_name 
		and i.debuff_stats.owner == get_tree().get_first_node_in_group("character")): 
			i.additional_debuff(source)
			return
	
	add_child(new_debuff)
	new_debuff.debuff_initializer(source)
	organize_debuffs()

func remove_debuff(debuff):
	for i in get_children():
		if i.debuff_stats.debuff_name == debuff:
			i.queue_free()
	organize_debuffs()

func organize_debuffs():
	var x_offset = 0
	for i in get_children():
		i.position = position + Vector2(x_offset + DEBUFF_X_POSITION, DEBUFF_Y_POSITION)
		i.scale = Vector2(1,1)
		x_offset += 50

