extends Node2D

class_name Skill

var skill_stats: Skills_Resource = null

var shop_label: Label
var shop_panel: Panel
var info_label: Label
var effect: Node2D
var skill_image: Sprite2D
var upgrade_border: Sprite2D


func _ready():
	set_node_names()

func upgrade_skill(num):
	set_node_names()
	effect.upgrade_skill(num)

func update_skill_image():
	upgrade_border.texture = load(skill_stats.skill_upgrade_art_path)

func skill_shop_ui():
	if skill_stats.owner != get_tree().get_first_node_in_group("character"):
		shop_label.text =  str(skill_stats.buy_price)

func toggle_shop_ui(show):
	if show: shop_panel.visible = true
	if Global.current_scene == "shop": return
	if !show:  shop_panel.visible = false

func set_node_names():
	shop_label = get_node('%ShopLabel')
	shop_panel = get_node('%ShopPanel')
	info_label = get_node('%InfoLabel')
	effect = get_node('%Effect')
	skill_image = get_node('%SkillImage')
	upgrade_border = get_node('%UpgradeBorder')
	
	skill_image.texture = load(skill_stats.skill_art_path)
	z_index = 1

#WIP TOOLTIPS======================================================================================
#func toggle_tooltip_show():
	#if $PopupPanel/VBoxContainer.get_children() == []: return
#
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
#
#func _on_panel_mouse_entered():
	#toggle_tooltip_show()
#
#func _on_panel_mouse_exited():
	#toggle_tooltip_hide()
