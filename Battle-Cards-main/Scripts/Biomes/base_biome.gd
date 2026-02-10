extends Node2D

@onready var biome_stats = get_parent().biome_stats
@onready var glow_effect = $GlowEffect

var glow_power = 3.0
var speed = 2.0

var tooltip_layer : CanvasLayer
var tooltip : Panel
var tooltip_container : VBoxContainer
var tooltip_name : Label
var biome_image : Sprite2D
var biome_border : Sprite2D
var collision_shape : CollisionShape2D

var disabled_collision = false


func _ready():
	set_node_names()
	get_parent().add_to_group("biome")
	self.scale = Global.ui_scaler

func _process(delta):
	if glow_effect:
		glow_power += delta * speed
		if glow_power >= 2.0 and speed > 0 or glow_power <= 1.0 and speed < 0:
			speed *= -1.0
		$GlowEffect.modulate.a = glow_power/ 4
		$GlowEffect.get_material().set_shader_parameter("glow_power", glow_power)

func set_node_names():
	tooltip_layer = get_node('%TooltipLayer')
	tooltip = tooltip_layer.get_child(0)
	tooltip_container = tooltip.get_child(0)
	collision_shape = get_node('%CollisionShape2D')
	biome_image = get_node('%BiomeImage')
	biome_border = get_node('%BorderImage')
	z_index = 1
	biome_image.texture = load(biome_stats.biome_art_path)
	biome_border.texture = load(biome_stats.biome_border_path)

func highlight_card(being_dragged):
	if being_dragged:
		z_index = 2
		$GlowEffect.visible = false
	else:
		z_index = 1
		$GlowEffect.visible = true

func disable_collision():
	collision_shape.disabled = true
	disabled_collision = true

func enable_collision():
	collision_shape.disabled = false
	disabled_collision = false

func toggle_tooltip_show(location):
	if tooltip_container.get_children() == []: return
	var mouse_pos = get_viewport().get_mouse_position()
	var correction = true
	var x_offset = 150
	var y_offset = -75
	tooltip.size = tooltip_container.size
	tooltip.visible = true
	tooltip_layer.visible = true
	self.scale = Vector2(1.2, 1.2)
	
	#Toggles when mouse is on LEFT side of screen
	if mouse_pos.x <= get_viewport_rect().size.x/2: correction = false
	
	if correction == false:
		#tooltip.popup(Rect2i(get_parent().position + Vector2(x_offset, y_offset), size)) 
		tooltip.position = Vector2(x_offset, y_offset) + location
	else:
		#tooltip.popup(Rect2i(get_parent().position, size)) 
		tooltip.position = Vector2(-x_offset - tooltip.size.x, y_offset) + location

func toggle_tooltip_hide():
	tooltip.visible = false
	tooltip_layer.visible = false
	self.scale = Vector2(1, 1)
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
