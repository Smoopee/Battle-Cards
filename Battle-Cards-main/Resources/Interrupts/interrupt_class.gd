extends Node2D


@onready var interrupt_stats = get_parent().interrupt_stats
@onready var glow_effect = $GlowEffect

var glow_power = 3.0
var speed = 2.0
var info_label: Label
var image_button: TextureButton
var tooltip : Panel
var tooltip_container : VBoxContainer

func _ready():
	self.scale = Global.ui_scaler
	set_node_names()
	add_to_group("interrupt")
	#effect.tooltip_effect()

func _process(delta):
	if glow_effect:
		glow_power += delta * speed
		if glow_power >= 2.0 and speed > 0 or glow_power <= 1.0 and speed < 0:
			speed *= -1.0
		$GlowEffect.modulate.a = glow_power/ 4
		$GlowEffect.get_material().set_shader_parameter("glow_power", glow_power)

func interrupt_effect(target):
	get_parent().effect(target)

func toggle_info_ui(show):
	if show: info_label.visible = true
	if !show: info_label.visible = false
	if interrupt_stats.stack_amount <= 1:  info_label.visible = false

func update_stack_ui():
	set_node_names()
	info_label.text = str(interrupt_stats.stack_amount)

func set_node_names():
	info_label = get_node('%InfoLabel')
	image_button = get_node('%ImageButton')
	tooltip = get_node('%TooltipPanel')
	tooltip_container = tooltip.get_child(0)
	
	image_button.texture_normal = load(interrupt_stats.interrupt_art_path)
	z_index = 1

#WIP TOOLTIPS======================================================================================
func toggle_tooltip_show():
	if tooltip_container.get_children() == []: return
	var mouse_pos = get_viewport().get_mouse_position()
	var correction = true
	var x_offset = 40
	var y_offset = -5
	tooltip.size = tooltip_container.size
	tooltip.visible = true
	
	#Toggles when mouse is on LEFT side of screen
	if mouse_pos.x <= get_viewport_rect().size.x/2: correction = false
	
	if correction == false:
		tooltip.position = Vector2(x_offset, y_offset)
	else:
		tooltip.position = Vector2(-x_offset - tooltip.size.x, y_offset)
		

func toggle_tooltip_hide():
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

func _on_interrupt_ui_mouse_entered():
	scale = Vector2(1.1, 1.1)
	toggle_tooltip_show()

func _on_interrupt_ui_mouse_exited():
	scale = Vector2(1, 1)
	toggle_tooltip_hide()


func _on_image_button_toggled(toggled_on: bool) -> void:
	if toggled_on: 
		%GlowEffect.visible = true
	else: 
		%GlowEffect.visible = false
	
	get_parent().interrupt_toggled(toggled_on)
