extends Node2D

func _ready():
	get_tree().get_first_node_in_group("character ui").toggle_inventory(true)
	get_tree().get_first_node_in_group("player skills").reset_skills()
	get_tree().get_first_node_in_group("main").is_pre_battle = true
	$NextTurn.initial_build()
	
	start_pre_battle_animation()
	get_tree().get_first_node_in_group("active spots").set_up_arrays()
	get_tree().get_first_node_in_group("active spots").apply_active_effects()

func start_pre_battle_animation():
	for i in get_tree().get_nodes_in_group("card"):
		if i.card_stats.in_active_zone:
			i.get_node("BaseCard").get_node("CardAnimationController")._pre_battle_animation(i.card_stats.owner)

func stop_pre_battle_animation():
	for i in get_tree().get_nodes_in_group("card"):
		i.get_node("BaseCard").get_node("CardAnimationController").stop_pre_battle_animation(i.card_stats.owner)
