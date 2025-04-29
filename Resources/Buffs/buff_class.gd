extends Node2D

class_name Buff

signal buff_removed

var buff_stats: Buff_Resource = null

var buff_image: Sprite2D
var buff_counter: Label
var buff_counter_panel: Panel
var effect: Node2D

func _ready():
	set_node_names()

func buff_initializer(source):
	effect.initialize(source)

func set_node_names():
	buff_counter = get_node('%BuffCounters')
	buff_counter_panel = get_node('%BuffCounterPanel')
	effect = get_node('%Effect')
	buff_image = get_node('%BuffImage')
	
	buff_image.texture = load(buff_stats.buff_art_path)
	z_index = 1

func set_counter(amount):
	buff_stats.count = amount
	buff_counter.text = str(buff_stats.count)
	if buff_stats.count <= 0: remove_buff()

func change_counter(amount):
	buff_stats.count += amount
	buff_counter.text = str(buff_stats.count)
	if buff_stats.count <= 0: remove_buff()

func remove_buff():
	emit_signal("buff_removed")
	queue_free()



#WIP TOOLTIP========================================================================================
#func toggle_tooltip_show():
	#if $PopupPanel/VBoxContainer.get_children() == []: return
	#var mouse_pos = get_viewport().get_mouse_position()
	#var correction 
	#
	#if mouse_pos.x <= get_viewport_rect().size.x/2:
		#correction = Vector2(0, 0)
	#else:
		##Toggles when mouse is on right side of screen
		#correction = -Vector2($PopupPanel/VBoxContainer.size.x + 310, 0)
	#$PopupPanel.popup(Rect2i(global_position + Vector2(20, -70) + correction, Vector2(0, 0)))
#
#func toggle_tooltip_hide():
	#$PopupPanel.hide()
#
#func update_tooltip(identifier, body = null, header = null,):
	#var tooltip
	#for i in $PopupPanel/VBoxContainer.get_children():
		#if i.name == identifier: 
			#tooltip = i
#
	#if tooltip == null:
		#var hbox = HBoxContainer.new()
		#hbox.name = identifier
		#$PopupPanel/VBoxContainer.add_child(hbox)
		#var name_label = Label.new()
		#hbox.add_child(name_label)
		#name_label.add_theme_color_override("font_color", Color.BLACK)
		#name_label.text = str(header)
		#var body_label = Label.new()
		#hbox.add_child(body_label)
		#body_label.add_theme_color_override("font_color", Color.BLACK)
		#body_label.text = str(body)
	#
	#else:
		#tooltip.get_child(1).text = str(body)
#
#func _on_panel_mouse_entered():
	#toggle_tooltip_show()
#
#func _on_panel_mouse_exited():
	#toggle_tooltip_hide()
