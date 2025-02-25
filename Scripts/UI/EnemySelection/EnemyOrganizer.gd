extends Node2D

const CARD_SCENE_PATH = "res://Scenes/UI/card.tscn"

var rng = RandomNumberGenerator.new()
var enemy_db_reference
var center_screen_x

func _ready():
	center_screen_x = get_viewport().size.x / 2
	enemy_db_reference = preload("res://Resources/Enemies/enemy_db.gd")
	
	var enemy_selection_array = []
	for i in enemy_db_reference.ENEMIES:
		enemy_selection_array.push_front(i)

	var enemy_array = []
	for i in range(0, 3):
		var enemy_pool_size = enemy_selection_array.size() - 1
		var selection = rng.randi_range(0, enemy_pool_size)
		enemy_array.push_front(enemy_db_reference.ENEMIES[enemy_selection_array[selection]])
		enemy_selection_array.remove_at(selection)

func create_encounter():
	pass
