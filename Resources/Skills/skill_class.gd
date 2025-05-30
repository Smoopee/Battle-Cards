extends Node2D

#class_name Skill


@onready var skill_stats = get_parent().skill_stats

var shop_label: Label
var shop_panel: Panel
var info_label: Label
var skill_image: Sprite2D
var upgrade_border: Sprite2D
var tooltip_container : VBoxContainer
var tooltip : Panel


func _ready():
	set_node_names()

func upgrade_skill(num):
	get_parent().upgrade_skill(num)

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
	skill_image = get_node('%SkillImage')
	upgrade_border = get_node('%UpgradeBorder')
	tooltip = get_node('%TooltipPanel')
	tooltip_container = tooltip.get_child(0)
	
	skill_image.texture = load(skill_stats.skill_art_path)
	z_index = 1

#WIP TOOLTIPS======================================================================================
func toggle_tooltip_show():
	if tooltip_container.get_children() == []: return
	toggle_shop_ui(true)
	var mouse_pos = get_viewport().get_mouse_position()
	var correction = true
	var x_offset = ($SkillUI.size.x /2) + 20
	var y_offset = -($SkillUI.size.y /2) + 11
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

func _on_skill_ui_mouse_entered():
	scale = Vector2(1.1, 1.1)
	toggle_tooltip_show()

func _on_skill_ui_mouse_exited():
	scale = Vector2(1, 1)
	toggle_tooltip_hide()
