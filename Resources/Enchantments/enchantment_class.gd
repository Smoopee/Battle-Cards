extends Node2D

class_name Enchantment

@onready var enchantment_stats = get_parent().enchantment_stats

var enchantment_image : Sprite2D
var ui : Control
var shop_panel : Panel
var shop_label : Label
var tooltip : Panel
var tooltip_container : VBoxContainer

func _ready():
	set_node_names()
	update_tooltip(str(enchantment_stats.enchantment_name), 
	"Flavor Text", 
	str(enchantment_stats.enchantment_tooltip), 
	"")

func enchantment_shop_ui():
	if enchantment_stats.enchantment_owner != get_tree().get_first_node_in_group("character"):
		shop_label.text =  str(enchantment_stats.buy_price)

func toggle_shop_ui(show):
	if show: shop_label.visible = true
	if Global.current_scene == "shop": return
	if !show: shop_label.visible = false

func set_node_names():
	enchantment_image = get_node('%EnchantmentImage')
	ui = get_node('%EnchantmentUI')
	shop_panel = get_node('%ShopPanel')
	shop_label = get_node('%ShopLabel')
	tooltip = get_node('%TooltipPanel')
	tooltip_container = tooltip.get_child(0)
	
	enchantment_image.texture = load(enchantment_stats.enchantment_art_path)
	add_to_group("enchantment")
	

#WIP TOOLTIPS======================================================================================
func toggle_tooltip_show():
	if tooltip_container.get_children() == []: return
	toggle_shop_ui(true)
	var mouse_pos = get_viewport().get_mouse_position()
	var correction = true
	var x_offset = (%EnchantmentUI.size.x /2) + 20
	var y_offset = -(%EnchantmentUI.size.y /2) + 11
	tooltip.size = tooltip_container.size
	tooltip.visible = true
	
	#Toggles when mouse is on LEFT side of screen
	if mouse_pos.x <= get_viewport_rect().size.x/2: correction = false
	
	if correction == false:
		tooltip.position = Vector2(x_offset, y_offset)
	else:
		tooltip.position = Vector2(-x_offset - tooltip.size.x, y_offset)

func toggle_tooltip_hide():
	toggle_shop_ui(false)
	tooltip.visible = false

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

func _on_enchantment_ui_mouse_entered():
	if get_tree().get_first_node_in_group("card manager").card_being_dragged != null: return
	scale = Vector2(1.1, 1.1)
	toggle_tooltip_show()

func _on_enchantment_ui_mouse_exited():
	scale = Vector2(1, 1)
	toggle_tooltip_hide()
