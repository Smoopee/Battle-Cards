extends Control

@onready var timer = $Timer
var mouse_occupied = false
var mouse_cursor_height = 20


func card_popup(card):
	if mouse_occupied: return
	timer.start(1)
	var tooltip = %CardPopup
	card.scale = Vector2(1.25, 1.25)
	var mouse_pos = get_viewport().get_mouse_position()
	var correction = true
	
	await timer.timeout
	if mouse_occupied or !mouse_leave_check(card): return
	#Toggles when mouse is on right side of screen
	if mouse_pos.x <= get_viewport_rect().size.x/2: correction = false
	
	if correction == false:
		tooltip.popup(Rect2i(card.position + Vector2(150, -180), Vector2i(0, 0))) 
	else:
		tooltip.popup(Rect2i(card.position, Vector2i(0, 0))) 
		tooltip.position = card.position + Vector2(-150 - tooltip.size.x , -180)
	return 
	
func hide_card_popup(card):
	card.scale = Vector2(1, 1)
	%CardPopup.hide()

func mouse_leave_check(card):
	if card == null: return
	var mouse_pos = get_viewport().get_mouse_position()
	var the_area = card.get_node("Area2D")
	var the_shape = the_area.get_child(0).shape
	var small_x = the_area.global_position.x - (the_shape.size.x / 2)
	var big_x = the_area.global_position.x + (the_shape.size.x / 2)
	var small_y = the_area.global_position.y - ((the_shape.size.y / 2) + mouse_cursor_height)
	var big_y = the_area.global_position.y + (the_shape.size.y / 2)


	if (mouse_pos.x >= small_x and 
	mouse_pos.x <= big_x and
	mouse_pos.y >= small_y and 
	mouse_pos.y <= big_y): 
		return true
	return false

func talent_popup(slot, talent_name, effect):
	return
	set_talent_values(talent_name, effect)
	
	var mouse_pos = get_viewport().get_mouse_position()
	var correction 
	
	if mouse_pos.x <= get_viewport_rect().size.x/1.3:
		#Changes padding from card -> tool tip, Higher number is less padding
		correction = Vector2i(slot.size.x , 0)
	else:
		correction = -Vector2i(%TalentPopup.size.x + 55, 0)
	
	%TalentPopup.popup(Rect2i(slot.position + correction, Vector2i(100,100)))
	%TalentPopup.position += Vector2i(0, 380)

func set_talent_values(talent_name, effect):
	$UI/TalentPopup/VBoxContainer/Name.text = str(talent_name)
	$UI/TalentPopup/VBoxContainer/HBoxContainer/Information.text = str(effect)

func hide_talent_popup():
	return
	%TalentPopup.hide()

