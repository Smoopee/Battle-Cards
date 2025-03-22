extends Node2D


const CARD_WIDTH = 150
const Y_POSITION = 620

var is_hoovering_on_card
var disabled_collision = false
var center_screen_x
var home_position

func _ready():
	center_screen_x = get_viewport().size.x / 2
	home_position = Vector2(center_screen_x, Y_POSITION)
	self.position = home_position

func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1)

func on_hoovered_over_card():
	highlight_card(true)

func on_hoovered_off_card():
	highlight_card(false)

func highlight_card(hoovered):
	if hoovered:
		scale = Vector2(1.05, 1.05)
		z_index = 2
	else:
		scale = Vector2(1, 1)
		z_index = 1

func _on_area_2d_mouse_entered():
	on_hoovered_over_card()

func _on_area_2d_mouse_exited():
	on_hoovered_off_card()
