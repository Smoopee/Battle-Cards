extends Node2D


func _ready():
	print("Current global merchant is " + str(Global.current_merchant))
	var merchant_resource = Global.current_merchant
	var merchant = load(merchant_resource.merchant_scene_path).instantiate()
	merchant.merchant_stats = merchant_resource
	add_child(merchant)
	
	var center_screen_x = get_viewport().size.x / 2
	merchant.position = Vector2(center_screen_x, 150)
