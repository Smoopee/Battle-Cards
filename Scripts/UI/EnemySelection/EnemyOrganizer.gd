extends Node2D

const CARD_WIDTH = 360
const ENEMY_Y_POSITION = 400

var rng = RandomNumberGenerator.new()
var enemy_db_reference
var center_screen_x
var enemy_resource_array = []
var enemy_array = []
var enemy_selection = []

func _ready():
	center_screen_x = get_viewport().size.x / 2
	enemy_db_reference = preload("res://Resources/Enemies/enemy_db.gd")

func enemy_setup(biome):
	get_enemy_selection(biome)
	create_enemy_selection()
	create_encounter()
	update_enemy_positions()

func get_enemy_selection(biome):
	for i in enemy_db_reference.ENEMIES:
		var temp = load(enemy_db_reference.ENEMIES[i])
		for j in temp.biomes:
			if j == biome:
				enemy_selection.push_back(temp)

func create_enemy_selection():
	for i in range(0, 3):
		var selection = random_enemy_selection()
		enemy_resource_array.push_front(selection)
	
func random_enemy_selection():
	var rng = RandomNumberGenerator.new()
	
	var enemy_selection_index = rng.randi_range(0, enemy_selection.size()-1)
	return enemy_selection[enemy_selection_index]

func create_encounter():
	for i in range(enemy_resource_array.size()):
		var new_enemy = load(enemy_resource_array[i].enemy_scene_path).instantiate().duplicate()
		new_enemy.character_stats = enemy_resource_array[i]
		add_child(new_enemy)
		
		new_enemy.get_node("BaseEnemy").get_node("EnemyUI").get_node("GoldAndXPBox").visible = true
		new_enemy.get_node("BaseEnemy").get_node("EnemyUI").get_node("EnemySelectionHealth").visible = true
		new_enemy.get_node("BaseEnemy").get_node("EnemyUI").get_node("EnemyHealthBar").visible = false
		enemy_array.push_front(new_enemy)

func update_enemy_positions():
	for i in range(enemy_array.size()):
		var new_position = Vector2(calculate_card_position(i), ENEMY_Y_POSITION)
		var enemy = enemy_array[i]
		enemy.position = new_position
 
func calculate_card_position(index):
	var total_width = (enemy_array.size() - 1) * CARD_WIDTH
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2
	return x_offset
