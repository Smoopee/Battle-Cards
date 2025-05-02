extends Node2D

class_name Enchantment

var enchantment_stats: Enchantments_Resource = null

var enchantment_image : Sprite2D
var ui : Control
var shop_panel : Panel
var shop_label : Label

func _ready():
	set_node_names()
	#update_tooltip("Effect","WIP",  "Effect: ")


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
	
	enchantment_image.texture = load(enchantment_stats.enchantment_art_path)
	add_to_group("enchantment")
	

#TOOLTIP WIP========================================================================================
#func toggle_tooltip_show():
	#if $PopupPanel/VBoxContainer.get_children() == []: return
	#$PopupPanel.popup(Rect2i(global_position + Vector2(20, -70), Vector2(0, 0)))
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
