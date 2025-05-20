extends Node2D

class_name Debuff


signal debuff_removed
signal counter_changed

var debuff_stats: Debuff_Resource = null

var debuff_image: Sprite2D
var debuff_counter: Label
var debuff_counter_panel: Panel
var effect: Node2D
var tooltip: PopupPanel
var tooltip_container: VBoxContainer

func _ready():
	set_node_names()

func debuff_initializer(source):
	effect.initialize(source)

func additional_debuff(source):
	effect.additional_debuff(source)

func set_node_names():
	debuff_counter = get_node('%DebuffCounters')
	debuff_counter_panel = get_node('%DebuffCounterPanel')
	effect = get_node('%Effect')
	debuff_image = get_node('%DebuffImage')
	tooltip = get_node('%PopupPanel')
	tooltip_container = get_node('%TooltipContainer')
	
	debuff_image.texture = load(debuff_stats.debuff_art_path)
	z_index = 1
	add_to_group("debuff")

func set_counter(amount):
	debuff_stats.count = amount
	debuff_counter.text = str(debuff_stats.count)
	emit_signal("counter_changed", debuff_stats.count)
	if debuff_stats.count <= 0: remove_debuff()

func change_counter(amount):
	debuff_stats.count += amount
	debuff_counter.text = str(debuff_stats.count)
	emit_signal("counter_changed", debuff_stats.count)
	if debuff_stats.count <= 0: remove_debuff()

func remove_debuff():
	emit_signal("debuff_removed")
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


func _on_debuff_ui_mouse_entered():
	scale = Vector2(1.1, 1.1)
	toggle_tooltip_show()


func _on_debuff_ui_mouse_exited():
	scale = Vector2(1, 1)
	toggle_tooltip_hide()
