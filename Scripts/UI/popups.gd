extends Control

@onready var tooltip = %PopupPanel
@onready var tooltip_container = %TooltipContainer


func toggle_tooltip_show():
	if tooltip_container.get_children() == []: return
	var mouse_pos = get_viewport().get_mouse_position()
	var correction = true
	var size = Vector2i(0,0)
	var x_offset = 85
	var y_offset = -105
	
	#Toggles when mouse is on right side of screen
	if mouse_pos.x <= get_viewport_rect().size.x/2: correction = false
	
	if correction == false:
		tooltip.popup(Rect2i(position + Vector2(x_offset, y_offset), size)) 
	else:
		tooltip.popup(Rect2i(position, size)) 
		tooltip.position = position + Vector2(-x_offset - tooltip.size.x , y_offset)


func toggle_tooltip_hide():
	var tooltip = %PopupPanel
	tooltip.hide()
