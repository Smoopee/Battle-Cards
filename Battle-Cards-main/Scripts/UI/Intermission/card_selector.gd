extends Node2D

@onready var glow_effect = $GlowEffect

const CARD_WIDTH = 190
const Y_POSITION = 810

var is_hoovering_on_card
var disabled_collision = false
var center_screen_x
var home_position

var glow_power = 3.0
var speed = 2.0


func _ready():
	center_screen_x = get_viewport().size.x / 2
	home_position = Vector2(center_screen_x, Y_POSITION)
	self.position = home_position
	self.scale = Global.ui_scaler


func _process(delta):
	if glow_effect:
		glow_power += delta * speed
		if glow_power >= 2.0 and speed > 0 or glow_power <= 1.0 and speed < 0:
			speed *= -1.0
		$GlowEffect.modulate.a = glow_power/ 4
		$GlowEffect.get_material().set_shader_parameter("glow_power", glow_power)

func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1)

func on_hoovered_over_card():
	highlight_card(true)

func on_hoovered_off_card():
	highlight_card(false)

func highlight_card(hoovered):
	if hoovered:
		z_index = 2
		$GlowEffect.visible = false
	else:
		z_index = 1
		$GlowEffect.visible = true

func _on_area_2d_mouse_entered():
	on_hoovered_over_card()

func _on_area_2d_mouse_exited():
	on_hoovered_off_card()
