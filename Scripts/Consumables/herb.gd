extends Node2D


func activate_consumable():
	var player = (get_tree().get_nodes_in_group("player")[0])
	Global.change_player_health(50)
	player.change_player_health()
