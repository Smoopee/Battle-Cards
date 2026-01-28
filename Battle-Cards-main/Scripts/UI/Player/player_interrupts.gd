extends Node2D


const INTERRUPT_Y_POSITION = -115

var interrupt_x_position = 0
var interrupt_array = []
var interrupt_width = 46


func _ready():
	set_interrupts()

func set_interrupts():
	var player_interrupts = Global.player_interrupts

	for i in player_interrupts:
		var new_instance = load(i.interrupt_scene_path).instantiate()
		new_instance.interrupt_stats = i
		add_child(new_instance)
		new_instance.get_node("BaseInterrupt").update_stack_ui()
		new_instance.get_node("BaseInterrupt").toggle_info_ui(true)
		
	organize_interrupts()

func add_interrupt(interrupt):
	for i in get_children():
		if i.interrupt_stats.name == interrupt.name:
			i.interrupt_stats.stack_amount += 1
			i.get_node("BaseInterrupt").update_stack_ui()
			i.get_node("BaseInterrupt").toggle_info_ui(true)
			return
			
	var new_instance = load(interrupt.interrupt_scene_path).instantiate()
	new_instance.interrupt_stats = interrupt
	add_child(new_instance)
	new_instance.get_node("BaseInterrupt").toggle_info_ui(true)
	organize_interrupts()

func remove_interrupt(interrupt, amount = 1):
	for i in get_children():
		if i.interrupt_stats.name == interrupt.name:
			i.interrupt_stats.stack_amount -= amount
			if i.interrupt_stats.stack_amount <= 0:
				remove_child(i)
				i.queue_free()
				organize_interrupts()
				return
			i.get_node("BaseInterrupt").update_stack_ui()
			i.get_node("BaseInterrupt").toggle_info_ui(true)
			organize_interrupts()
			return

func organize_interrupts():
	var x_offset = 0
	
	for i in get_children():
		interrupt_array.push_front(i)
		update_interrupt_positions()
		print(i.global_position)
		#i.global_position = Vector2(x_offset + interrupt_x_position, INTERRUPT_Y_POSITION)
		#x_offset += 20

func update_interrupt_positions():
	for i in range(interrupt_array.size()):
		var new_position = Vector2(calculate_interrupt_position(i), INTERRUPT_Y_POSITION)
		var interrupt = interrupt_array[i]
		interrupt.global_position = new_position - Vector2(960, 0)

func calculate_interrupt_position(index):
	var total_width = (interrupt_array.size() - 1) * interrupt_width * Global.ui_scaler.x 
	var x_offset = Global.center_screen_x + index * interrupt_width * Global.ui_scaler.x - total_width / 2
	return x_offset

func get_interrupt_array():
	var interrupt_array = []
	for i in get_children():
		interrupt_array.push_back(i.interrupt_stats)
	
	return interrupt_array

func enable_interrupts():
	for i in get_tree().get_nodes_in_group("interrupt"):
		i.image_button.disabled = false

func disable_interrupts():
	for i in get_tree().get_nodes_in_group("interrupt"):
		i.image_button.disabled = true
