extends Node2D

const CARD_WIDTH = 350
const EVENT_Y_POSITION = 400

var rng = RandomNumberGenerator.new()
var center_screen_x
var biome_event_array = []
var biome_event_selection = []
var biome_event_db_reference

func _ready():
	center_screen_x = get_viewport().size.x / 2
	biome_event_db_reference = preload("res://Resources/Biomes/biome_db.gd")
	
	var biome_event_selection_array = []
	for i in biome_event_db_reference.BIOMES:
		biome_event_selection_array.push_front(i)

	for i in range(0, 3):
		var event_pool_size = biome_event_selection_array.size() - 1
		var selection = rng.randi_range(0, event_pool_size)
		var new_instance = load(biome_event_db_reference.BIOMES[biome_event_selection_array[selection]])
		biome_event_array.push_front(new_instance)
		biome_event_selection_array.remove_at(selection)

	create_encounter(biome_event_array)

func create_encounter(biome_event_array):
	for i in range(biome_event_array.size()):
		var new_event = biome_event_array[i].instantiate()
		add_child(new_event)
		biome_event_selection.push_front(new_event)
		update_event_positions()

func update_event_positions():
	for i in range(biome_event_selection.size()):
		var new_position = Vector2(calculate_card_position(i), EVENT_Y_POSITION)
		var event = biome_event_selection[i]
		event.position = new_position
 
func calculate_card_position(index):
	var total_width = (biome_event_selection.size() - 1) * CARD_WIDTH
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2
	return x_offset

func clear_biomes():
	for i in get_children():
		i.queue_free()
