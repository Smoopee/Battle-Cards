extends Node2D

const CARD_SCENE_PATH = "res://Scenes/UI/card.tscn"
const CARD_WIDTH = 150
const ENEMY_Y_POSITION = 590

var rng = RandomNumberGenerator.new()
var enemy_db_reference
var center_screen_x
var enemy_array = []
var enemy_selection = []

func _ready():
	center_screen_x = get_viewport().size.x / 2
	enemy_db_reference = preload("res://Resources/Enemies/enemy_db.gd")
	
	var enemy_selection_array = []
	for i in enemy_db_reference.ENEMIES:
		enemy_selection_array.push_front(i)

	for i in range(0, 3):
		var enemy_pool_size = enemy_selection_array.size() - 1
		var selection = rng.randi_range(0, enemy_pool_size)
		var new_instance = load(enemy_db_reference.ENEMIES[enemy_selection_array[selection]])
		enemy_array.push_front(new_instance)
		enemy_selection_array.remove_at(selection)
		
	create_encounter(enemy_array)

func create_encounter(enemy_array):
	var card = preload("res://Scenes/UI/card.tscn")
	
	for i in range(enemy_array.size()):
		var enemy_scene = card
		var new_enemy = enemy_scene.instantiate()
		new_enemy.get_node("CardImage").texture = load(enemy_array[i].enemy_art_path)
		new_enemy.get_node("Area2D").collision_layer = 2
		new_enemy.get_node("Area2D").collision_mask = 2
		new_enemy.card_resource = enemy_array[i]
		add_child(new_enemy)
		enemy_selection.push_front(new_enemy)
		update_enemy_positions()

func update_enemy_positions():
	for i in range(enemy_selection.size()):
		var new_position = Vector2(calculate_card_position(i), ENEMY_Y_POSITION)
		var enemy = enemy_selection[i]
		enemy.position = new_position
 
func calculate_card_position(index):
	var total_width = (enemy_selection.size() - 1) * CARD_WIDTH
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2
	return x_offset
