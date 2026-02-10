extends Node2D

class_name Buff

signal buff_removed
signal counter_changed

@onready var buff_stats = get_parent().buff_stats

var buff_image: Sprite2D
var buff_counter: Label
var buff_counter_panel: Panel
var tooltip_layer : CanvasLayer
var tooltip: Panel
var tooltip_container: VBoxContainer

func _ready():
	set_node_names()

func set_node_names():
	buff_counter = get_node('%BuffCounters')
	buff_counter_panel = get_node('%BuffCounterPanel')
	buff_image = get_node('%BuffImage')
	tooltip_layer = get_node('%TooltipLayer')
	tooltip = tooltip_layer.get_child(0)
	tooltip_container = tooltip.get_child(0)
	buff_image.texture = load(buff_stats.buff_art_path)
	z_index = 1
	add_to_group("buff")

func set_counter(amount):
	buff_stats.count = amount
	buff_counter.text = str(buff_stats.count)
	emit_signal("counter_changed", buff_stats.count)

func change_counter(amount):
	buff_stats.count += amount
	buff_counter.text = str(buff_stats.count)
	emit_signal("counter_changed", buff_stats.count)

func remove_buff():
	if buff_stats.owner.is_in_group("character"):
		get_tree().get_first_node_in_group("player buffs").remove_buff(get_parent())
	if buff_stats.owner.is_in_group("enemy"):
		get_tree().get_first_node_in_group("enemy buffs").remove_buff(get_parent())
	emit_signal("buff_removed", get_parent())

#WIP TOOLTIP========================================================================================
func toggle_tooltip_show(location):
	if tooltip_container.get_children() == []: return
	var mouse_pos = get_viewport().get_mouse_position()
	var correction = true
	var x_offset = 40
	var y_offset = -5
	self.scale = Vector2(1.25, 1.25)
	tooltip.size = tooltip_container.size
	tooltip.visible = true
	tooltip_layer.visible = true
	
	#Toggles when mouse is on LEFT side of screen
	if mouse_pos.x <= get_viewport_rect().size.x/2: correction = false
	
	if correction == false:
		tooltip.position = Vector2(x_offset, y_offset) + location
	else:
		tooltip.position = Vector2(-x_offset - tooltip.size.x, y_offset) + location
		

func toggle_tooltip_hide():
	tooltip.visible = false
	tooltip_layer.visible = false
	self.scale = Vector2(1, 1)

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
