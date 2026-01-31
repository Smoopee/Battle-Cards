extends Node2D

const GADGET_X_POSITION = -100
const GADGET_Y_POSITION = -60
const GADGET_Y_HORIZONTAL_POSITION = 950

func _ready():
	set_gadgets()
	get_tree().get_first_node_in_group("main").connect("scene_change", gadget_connect)

func gadget_connect(scene):
	for i in get_children():
		i.gadget_signal_connect(scene)

func set_gadgets():
	var player_gadgets = Global.player_gadgets

	for i in player_gadgets:
		var new_instance = load(i.gadget_scene_path).instantiate()
		new_instance.gadget_stats = i
		add_child(new_instance)
		
	organize_gadgets()

func add_gadget(gadget):
	for i in get_children():
		if i.gadget_stats.name == gadget.name:
			i.gadget_stats.stack_amount += 1
			return
			
	var new_instance = load(gadget.gadget_scene_path).instantiate()
	new_instance.gadget_stats = gadget
	add_child(new_instance)
	organize_gadgets()

func remove_gadget(gadget, amount = 1):
	for i in get_children():
		if i.gadget_stats.name == gadget.name:
			i.gadget_stats.stack_amount -= amount
			if i.gadget_stats.stack_amount <= 0:
				remove_child(i)
				i.queue_free()
				organize_gadgets()
				return
			organize_gadgets()
			return
			
func organize_gadgets():
	var counter = 0
	var x_offset = 0
	var y_offset = -5
	
	for i in get_children():
		if counter >= 4: 
			x_offset = -32 
			y_offset = 0
			counter = 0
		i.position = Vector2(x_offset + GADGET_X_POSITION - $"../ItemsUI".size.x, y_offset + GADGET_Y_POSITION)
		y_offset += 50 
		counter += 1

func get_gadget_array():
	var gadget_array = []
	for i in get_children():
		gadget_array.push_back(i.gadget_stats)
	
	return gadget_array
