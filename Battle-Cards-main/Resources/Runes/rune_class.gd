extends Node2D

#class_name Rune

@onready var rune_stats = get_parent().rune_stats

var shop_label: Label
var shop_panel: Panel
var rune_image: Sprite2D
var tooltip_layer: CanvasLayer
var tooltip: Panel
var tooltip_container: VBoxContainer


func _ready():
	self.scale = Global.ui_scaler
	set_node_names()

func set_node_names():
	shop_label = get_node('%ShopLabel')
	shop_panel = get_node('%ShopPanel')
	rune_image = get_node('%RuneImage')
	tooltip_layer = get_node('%TooltipLayer')
	tooltip = tooltip_layer.get_child(0)
	tooltip_container = tooltip.get_child(0)
	
	rune_image.texture = load(rune_stats.rune_art_path)
	z_index = 1

func rune_shop_ui():
	if rune_stats.owner != get_tree().get_first_node_in_group("character"):
		shop_label.text =  str(rune_stats.buy_price)

func toggle_shop_ui(show):
	if show: shop_panel.visible = true
	if Global.current_scene == "shop": return
	if !show: shop_panel.visible = false

#WIP TOOLTIPS======================================================================================
func toggle_tooltip_show(location):
	if tooltip_container.get_children() == []: return
	toggle_shop_ui(true)
	var mouse_pos = get_viewport().get_mouse_position()
	var correction = true
	var x_offset = ($RuneUI.size.x /2) + 20
	var y_offset = -($RuneUI.size.y /2) + 11
	tooltip.size = tooltip_container.size
	tooltip.visible = true
	tooltip_layer.visible = true
	
	
	#Toggles when mouse is on LEFT side of screen
	if mouse_pos.x <= get_viewport_rect().size.x/2: correction = false
	
	if correction == false:
		#tooltip.popup(Rect2i(get_parent().position + Vector2(x_offset, y_offset), size)) 
		tooltip.position = Vector2(x_offset, y_offset) + location
	else:
		#tooltip.popup(Rect2i(get_parent().position, size)) 
		tooltip.position = Vector2(-x_offset - tooltip.size.x, y_offset) + location
		

func toggle_tooltip_hide():
	toggle_shop_ui(false)
	tooltip.visible = false
	tooltip_layer.visible = false
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
