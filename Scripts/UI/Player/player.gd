extends Node2D


func _ready():
	var center_screen_x = get_viewport().size.x / 2
	self.position = Vector2(center_screen_x, 810)
	
	$PlayerHealthBar.max_value = Global.max_player_health
	$PlayerHealthBar.value = Global.player_health
	$PlayerHealthBar/PlayerHealthLabel.text = str($PlayerHealthBar.value) + "/" + str($PlayerHealthBar.max_value)


func change_player_health():
	$PlayerHealthBar.value = Global.player_health
	$PlayerHealthBar/PlayerHealthLabel.text = str($PlayerHealthBar.value) + "/" + str($PlayerHealthBar.max_value)
