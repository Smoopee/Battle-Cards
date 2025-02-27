extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var merchant = load(Global.current_merchant).instantiate()
	add_child(merchant)
	
	var center_screen_x = get_viewport().size.x / 2
	merchant.position = Vector2(center_screen_x, 150)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
