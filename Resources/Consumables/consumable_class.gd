extends Node2D

#class_name TestCard

@onready var consumable_stats = get_parent().consumable_stats

var shop_label: Label
var shop_panel: Panel
var info_label: Label
var image: Sprite2D
var tooltip : Panel
var tooltip_container : VBoxContainer

func _ready():
	set_node_names()
	#effect.tooltip_effect()

func consumable_effect(target):
	get_parent().effect(target)

func consumable_shop_ui():
	if consumable_stats.consumable_owner != get_tree().get_first_node_in_group("character"):
		shop_label.text =  str(consumable_stats.buy_price)

func toggle_shop_ui(show):
	if show: shop_panel.visible = true
	if Global.current_scene == "shop": return
	if !show: shop_panel.visible = false

func toggle_info_ui(show):
	if show: info_label.visible = true
	if !show: info_label.visible = false
	if consumable_stats.stack_amount <= 1:  info_label.visible = false

func update_stack_ui():
	set_node_names()
	info_label.text = str(consumable_stats.stack_amount)

func set_node_names():
	shop_label = get_node('%ShopLabel')
	shop_panel = get_node('%ShopPanel')
	info_label = get_node('%InfoLabel')
	image = get_node('%ConsumableImage')
	tooltip = get_node('%TooltipPanel')
	tooltip_container = get_node('%TooltipContainer')
	
	image.texture = load(consumable_stats.consumable_art_path)
	z_index = 1

#WIP TOOLTIPS======================================================================================
func toggle_tooltip_show():
	if tooltip_container.get_children() == []: return
	toggle_shop_ui(true)
	var mouse_pos = get_viewport().get_mouse_position()
	var correction = true
	var x_offset = 40
	var y_offset = -5
	tooltip.size = tooltip_container.size
	tooltip.visible = true
	
	#Toggles when mouse is on LEFT side of screen
	if mouse_pos.x <= get_viewport_rect().size.x/2: correction = false
	
	if correction == false:
		#tooltip.popup(Rect2i(get_parent().position + Vector2(x_offset, y_offset), size)) 
		tooltip.position = Vector2(x_offset, y_offset)
	else:
		#tooltip.popup(Rect2i(get_parent().position, size)) 
		tooltip.position = Vector2(-x_offset - tooltip.size.x, y_offset)
		

func toggle_tooltip_hide():
	toggle_shop_ui(false)
	tooltip.visible = false
	#tooltip.hide()

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

func _on_consumable_ui_mouse_entered():
	scale = Vector2(1.1, 1.1)
	toggle_tooltip_show()

func _on_consumable_ui_mouse_exited():
	scale = Vector2(1, 1)
	toggle_tooltip_hide()
