extends Node2D

@onready var tooltip = %PopupPanel
@onready var tooltip_container = %TooltipContainer

var merchant_stats: Merchant_Resource = null

func _ready():
	update_tooltip(str(merchant_stats.merchant_name), 
	"Flavor Text", 
	"Head into town. \nSkip the second Intermission.", 
	"")

#WIP TOOLTIPS======================================================================================
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
		tooltip.popup(Rect2i(global_position + Vector2(x_offset, y_offset), size)) 
	else:
		var new_position = global_position + Vector2(-x_offset - tooltip.size.x , y_offset)
		tooltip.popup(Rect2i(new_position, size)) 
		

func toggle_tooltip_hide():
	tooltip.hide()

func update_tooltip(category, identifier, body = null, header = null):
	var temp
	for i in tooltip_container.get_children():
		if i.name == category: 
			temp = i
	if temp == null:
		var new_tooltip = load("res://tooltip_bg.tscn").instantiate()
		tooltip_container.add_child(new_tooltip)
		new_tooltip.create_tooltip(category, identifier, body, header)
	else:
		temp.update_tooltip(category, identifier, body, header)

func _on_merchant_ui_mouse_entered():
	if get_tree().get_first_node_in_group("card manager").card_being_dragged != null: return
	scale = Vector2(1.1, 1.1)
	toggle_tooltip_show()

func _on_merchant_ui_mouse_exited():
	scale = Vector2(1, 1)
	toggle_tooltip_hide()
