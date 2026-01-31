extends Node2D


func instantiate_runes():
	for i in get_parent().character_stats.runes:
		var temp = load(i.rune_scene_path).instantiate().duplicate()
		temp.rune_stats = i
		temp.rune_stats.owner = get_tree().get_first_node_in_group("base enemy")
		add_child(temp)
		temp.activate_rune()
		get_parent().organize_runes()
