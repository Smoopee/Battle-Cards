extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	print($Sprite2D.position)
	$Panel.position =  Vector2(400, -400)
	$Panel.size = $Panel/VBoxContainer.size + Vector2(20, 20)
	$Panel/VBoxContainer.position = Vector2(10, 10)
