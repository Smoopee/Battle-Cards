extends Node2D

var player_skill = true


func effect():
	get_parent().get_parent().player_armor += 1
	
