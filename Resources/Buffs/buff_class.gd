extends Node2D

class_name Buff

signal buff_removed
signal counter_changed

var buff_stats: Buff_Resource = null

var buff_image: Sprite2D
var buff_counter: Label
var buff_counter_panel: Panel
var effect: Node2D
var tooltip: PopupPanel
var tooltip_container: VBoxContainer

func _ready():
	set_node_names()
	
func buff_initializer(source):
	effect.initialize(source)

func additional_buff(source):
	effect.additional_buff(source)

func set_node_names():
	buff_counter = get_node('%BuffCounters')
	buff_counter_panel = get_node('%BuffCounterPanel')
	effect = get_node('%Effect')
	buff_image = get_node('%BuffImage')
	tooltip = get_node('%PopupPanel')
	tooltip_container = get_node('%TooltipContainer')
	
	buff_image.texture = load(buff_stats.buff_art_path)
	z_index = 1
	add_to_group("buff")

func set_counter(amount):
	buff_stats.count = amount
	buff_counter.text = str(buff_stats.count)
	emit_signal("counter_changed", buff_stats.count)
	if buff_stats.count <= 0: remove_buff()

func change_counter(amount):
	buff_stats.count += amount
	buff_counter.text = str(buff_stats.count)
	emit_signal("counter_changed", buff_stats.count)
	if buff_stats.count <= 0: remove_buff()

func remove_buff():
	emit_signal("buff_removed")
	queue_free()


#WIP TOOLTIP========================================================================================
func toggle_tooltip_show():
	if tooltip_container.get_children() == []: return
	var mouse_pos = get_viewport().get_mouse_position()
	var correction = true
	var size = Vector2i(0,0)
	
	#Toggles when mouse is on right side of screen
	if mouse_pos.x <= get_viewport_rect().size.x/2: correction = false
	
	if correction == false:
		tooltip.popup(Rect2i(global_position + Vector2(25, -35), size)) 
	else:
		var new_position = global_position + Vector2(-25 - tooltip.size.x , -35)
		tooltip.popup(Rect2i(new_position, size)) 
		

func toggle_tooltip_hide():
	tooltip.hide()

func update_tooltip(category, identifier, body = null, header = null):
	var temp
	for i in tooltip_container.get_children():
		if i.name == category: 
			temp = i
	if temp == null:
		var new_tooltip = load("res://Scenes/UI/Tooltips/tooltip_bg.tscn").instantiate()
		tooltip_container.add_child(new_tooltip)
		new_tooltip.create_tooltip(category, identifier, body, header)
	else:
		temp.update_tooltip(category, identifier, body, header)


func _on_buff_ui_mouse_entered():
	scale = Vector2(1.1, 1.1)
	toggle_tooltip_show()


func _on_buff_ui_mouse_exited():
	scale = Vector2(1, 1)
	toggle_tooltip_hide()
