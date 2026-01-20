extends Node2D

const PORTRAIT_Y_POSITION = 820

func _ready():
	var center_screen_x = get_viewport().size.x / 2
	self.position = Vector2(center_screen_x, PORTRAIT_Y_POSITION)
	self.scale = Global.ui_scaler
