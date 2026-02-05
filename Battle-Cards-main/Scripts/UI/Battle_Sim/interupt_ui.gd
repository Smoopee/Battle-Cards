extends Control

@onready var organizer = $HBox

var turn_interupt_array = [false, false, false, false, false, false, false]


func set_size_and_position():
	var screen_size = get_viewport_rect().size
	self.size.x = $"../Enemy".total_card_area_width
	self.position.x = screen_size.x /2 - self.size.x /2
	self.position.y = screen_size. y/2 - self.size.y /2
	organizer.size.x = self.size.x

func interupt_reset():
	$MasterToggle.button_pressed = false
	for i in organizer.get_children():
		i.button_pressed = false

func _on_check_box_toggled(toggled_on: bool) -> void:
	turn_interupt_array[0] = toggled_on


func _on_check_box_2_toggled(toggled_on: bool) -> void:
	turn_interupt_array[1] = toggled_on


func _on_check_box_3_toggled(toggled_on: bool) -> void:
	turn_interupt_array[2] = toggled_on


func _on_check_box_4_toggled(toggled_on: bool) -> void:
	turn_interupt_array[3] = toggled_on


func _on_check_box_5_toggled(toggled_on: bool) -> void:
	turn_interupt_array[4] = toggled_on


func _on_check_box_6_toggled(toggled_on: bool) -> void:
	turn_interupt_array[5] = toggled_on


func _on_check_box_7_toggled(toggled_on: bool) -> void:
	turn_interupt_array[6] = toggled_on


func _on_master_toggle_toggled(toggled_on: bool) -> void:
	if toggled_on:
		for i in organizer.get_children():
			i.button_pressed = true
	else:
		for i in organizer.get_children():
			i.button_pressed = false
