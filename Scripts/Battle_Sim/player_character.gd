extends Node2D


func _ready():
	pass 

func load_character():
	var character = preload("res://Scenes/Characters/berserker.tscn")
	
	var new_instance = character.instantiate()
	add_child(new_instance)
