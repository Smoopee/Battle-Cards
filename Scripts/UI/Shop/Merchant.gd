extends Node2D


func _ready():
	var merchant = load(Global.current_merchant).instantiate()
	add_child(merchant)
	
	var center_screen_x = get_viewport().size.x / 2
	merchant.position = Vector2(center_screen_x, 150)
	merchant.get_node("Area2D").collision_layer = 4
	merchant.get_node("Area2D").collision_mask = 4

