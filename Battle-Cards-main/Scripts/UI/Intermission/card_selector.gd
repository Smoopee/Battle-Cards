extends Node2D

const CARD_WIDTH = 190

var is_hoovering_on_card
var disabled_collision = false
var center_screen_x
var home_position
var original_rotation
var is_being_dragged = false


func _ready():
	center_screen_x = get_viewport().size.x / 2
	home_position = Vector2(Global.center_screen_x, 920)
	self.position = home_position
	original_rotation = self.rotation
	self.scale = Global.ui_scaler

func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1)
	
	hide_node()

func hide_node():
	self.visible = false
	$CanvasLayer/CardArc.visible = false

func show_node():
	self.visible = true
	$CanvasLayer/CardArc.visible = true

func _get_points():
	var points := []
	var start :=  Vector2(Global.center_screen_x, 870)
	var target = get_global_mouse_position()
	var distance = (target-start)
	
	var arc_points = 12
	
	for i in range(arc_points):
		var t = (1.0 / arc_points) * i
		var x = start.x + (distance.x / arc_points) * i
		var y = start.y + ease_out_cubic(t) * distance.y
		points.append(Vector2(x,y))
	
	points.append(target)
	var temp_position = points[11]
	return points
	
func ease_out_cubic(number : float) -> float:
	return 1.0 - pow(1.0 - number, 2.0)


func draw_a_line():
	var temp_points = _get_points()
	
	$CanvasLayer/CardArc.points = temp_points
	var line_length = temp_points[0].distance_to(temp_points[12])
	if line_length >= 0 and line_length < 100:
		look_at(temp_points[6])
	if line_length >= 100 and line_length < 200:
		look_at(temp_points[6])
	if line_length >= 200 and line_length < 300:
		look_at(temp_points[7])
	if line_length >= 300 and line_length < 400:
		look_at(temp_points[8])
	if line_length >= 400 and line_length < 500:
		look_at(temp_points[8])
	if line_length >= 500 and line_length < 600:
		look_at(temp_points[9])
	if line_length >= 600 and line_length < 700:
		look_at(temp_points[9])
	if line_length >= 700 and line_length < 800:
		look_at(temp_points[10])
	if line_length >= 800 and line_length < 900:
		look_at(temp_points[10])
	if line_length >= 900 and line_length < 1000:
		look_at(temp_points[10])
	if line_length >= 1000 and line_length < 1100:
		look_at(temp_points[11])
	if line_length >= 1100 and line_length < 1200:
		look_at(temp_points[11])
	if line_length >= 1200:
		look_at(temp_points[12])
		print("12")

#func on_hoovered_over_card():
	#highlight_card(true)
#
#func on_hoovered_off_card():
	#highlight_card(false)

func highlight_card(being_dragged):
	if being_dragged:
		z_index = 2
	else:
		z_index = 1

#func _on_area_2d_mouse_entered():
	#on_hoovered_over_card()
#
#func _on_area_2d_mouse_exited():
	#on_hoovered_off_card()
