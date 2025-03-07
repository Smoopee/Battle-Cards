extends Node2D


func _ready():
	print("Current global merchant is " + str(Global.current_merchant))
	var merchant = load(Global.current_merchant).instantiate()
	add_child(merchant)
	
	var center_screen_x = get_viewport().size.x / 2
	merchant.position = Vector2(center_screen_x, 150)


