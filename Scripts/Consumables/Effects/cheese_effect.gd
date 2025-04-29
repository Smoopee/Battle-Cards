extends Node2D

func effect(player):
	print("In cheese consumable")
	if Global.current_scene != "battle_sim": return false
	var buff_resource = load('res://Resources/Buffs/cheese.tres')
	var new_buff = load(buff_resource.buff_scene_path).instantiate()
	new_buff.buff_stats = buff_resource
	new_buff.buff_stats.owner = player
	player.add_buff(new_buff, self)
	return true
