extends Node2D

const RUNE_X_POSITION = -100
const RUNE_Y_POSITION = -60
const RUNE_Y_HORIZONTAL_POSITION = 950


func _ready():
	set_runes()

func set_runes():
	var player_runes = Global.player_runes

	for i in player_runes:
		var new_instance = load(i.rune_scene_path).instantiate()
		new_instance.rune_stats = i
		add_child(new_instance)
		
	organize_runes()

func add_rune(rune):
	for i in get_children():
		if i.rune_stats.rune_name == rune.rune_name:
			i.rune_stats.stack_amount += 1
			return
			
	var new_instance = load(rune.rune_scene_path).instantiate()
	new_instance.rune_stats = rune
	add_child(new_instance)
	organize_runes()

func remove_rune(rune, amount = 1):
	for i in get_children():
		if i.rune_stats.name == rune.name:
			i.rune_stats.stack_amount -= amount
			if i.rune_stats.stack_amount <= 0:
				remove_child(i)
				i.queue_free()
				organize_runes()
				return
			organize_runes()
			return
			
func organize_runes():
	var counter = 0
	var x_offset = 0
	var y_offset = -5
	
	for i in get_children():
		if counter >= 4: 
			x_offset = -32 
			y_offset = 0
			counter = 0
		i.position = Vector2(x_offset + RUNE_X_POSITION - $"../ItemsUI".size.x, y_offset + RUNE_Y_POSITION)
		y_offset += 45
		counter += 1

func get_rune_array():
	var rune_array = []
	for i in get_children():
		rune_array.push_back(i.rune_stats)
	
	return rune_array
