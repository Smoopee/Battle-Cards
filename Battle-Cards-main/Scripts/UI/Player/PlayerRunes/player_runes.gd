extends Node2D

const RUNE_X_POSITION = -150
const RUNE_Y_POSITION = -60


func _ready():
	set_runes()


#RUNES =============================================================================================
func set_runes():
	var player_runes = Global.player_runes

	for i in player_runes:
		var new_instance = load(i.rune_scene_path).instantiate()
		new_instance.rune_stats = i
		add_child(new_instance)
	
	organize_runes()

func add_rune(rune):
	var new_instance = load(rune.rune_scene_path).instantiate()
	new_instance.rune_stats = rune
	add_child(new_instance)
	organize_runes()

func organize_runes():
	var counter = 0
	var x_offset = 0
	var y_offset = 0
	
	for i in get_children():
		if counter >= 5: 
			x_offset = -32
			y_offset = 0
			counter = 0
		i.position = Vector2(x_offset + RUNE_X_POSITION, y_offset + RUNE_Y_POSITION)
		y_offset += 30
		counter += 1

func get_rune_array():
	var rune_array = []
	for i in get_children():
		rune_array.push_back(i.rune_stats)
	
	return rune_array
