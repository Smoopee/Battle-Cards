extends Node2D

var player_deck = Global.player_deck


func _ready():
	pass

func build_deck():
	for i in player_deck:
		var new_instance = load(i).instantiate()
		add_child(new_instance)
