extends Node2D


var center_screen_x

func _ready():
	center_screen_x = get_viewport().size.x / 2
	
	self.position = Vector2(center_screen_x, 500)
