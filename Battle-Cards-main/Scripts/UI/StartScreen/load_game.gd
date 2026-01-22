extends Node2D

@onready var glow_effect = $GlowEffect


var glow_power = 3.0
var speed = 2.0

func _ready():
	self.position = Vector2(Global.center_screen_x, 500)
	self.scale = Global.ui_scaler

func _process(delta):
	if glow_effect:
		glow_power += delta * speed
		if glow_power >= 2.0 and speed > 0 or glow_power <= 1.0 and speed < 0:
			speed *= -1.0
		$GlowEffect.modulate.a = glow_power/ 4
		$GlowEffect.get_material().set_shader_parameter("glow_power", glow_power)

func highlight_card(being_dragged):
	if being_dragged:
		z_index = 2
		$GlowEffect.visible = false
	else:
		z_index = 1
		$GlowEffect.visible = true
