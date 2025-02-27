extends Node2D

var player_deck = Global.player_deck


func build_deck():
	for i in player_deck:
		var new_instance = load(i).instantiate()
		add_child(new_instance)
	
	var deck_array = []
	var counter = 0
	
	for i in get_children():
		deck_array.push_back(i)
	
	for i in deck_array:
		i.card_stats.position = counter
		counter += 1
	
	return deck_array
