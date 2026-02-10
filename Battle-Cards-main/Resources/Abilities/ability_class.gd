extends Node2D


@onready var ability_stats = get_parent().ability_stats
@onready var glow_effect = $GlowEffect

var glow_power = 3.0
var speed = 2.0
var info_label: Label
var ability_image: Sprite2D
var tooltip_layer: CanvasLayer
var tooltip : Panel
var tooltip_container : VBoxContainer

var button_toggle = false

func _ready():
	self.scale = Global.ui_scaler
	set_node_names()
	add_to_group("ability")
	#effect.tooltip_effect()

func _process(delta):
	if glow_effect:
		glow_power += delta * speed
		if glow_power >= 2.0 and speed > 0 or glow_power <= 1.0 and speed < 0:
			speed *= -1.0
		$GlowEffect.modulate.a = glow_power/ 4
		$GlowEffect.get_material().set_shader_parameter("glow_power", glow_power)



func ability_effect(target):
	get_parent().effect(target)

func toggle_info_ui(show):
	if show: info_label.visible = true
	if !show: info_label.visible = false


func set_node_names():
	info_label = get_node('%InfoLabel')
	ability_image = get_node('%AbilityImage')
	tooltip_layer = get_node('%TooltipLayer')
	tooltip = tooltip_layer.get_child(0)
	tooltip_container = tooltip.get_child(0)
	ability_image.texture = load(ability_stats.ability_art_path)
	z_index = 1

#WIP TOOLTIPS======================================================================================
func toggle_tooltip_show(location):
	
	if tooltip_container.get_children() == []: return
	var mouse_pos = get_viewport().get_mouse_position()
	var correction = true
	var x_offset = 40
	var y_offset = -5
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

func set_info_label():
	info_label.text = str(ability_stats.cost)

func update_ability_image():
	set_info_label()
	
func toggle_glow(toggled_on):
	if toggled_on: 
		%GlowEffect.visible = true
	else: 
		%GlowEffect.visible = false
	
func button_pressed():
	if button_toggle == false:
		get_parent().ability_toggled(true)
		button_toggle = true
	else:
		get_parent().ability_toggled(false)
		button_toggle = false
