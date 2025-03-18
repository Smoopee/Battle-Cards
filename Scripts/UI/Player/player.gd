extends Node2D


func _ready():
	var center_screen_x = get_viewport().size.x / 2
	self.position = Vector2(center_screen_x, 900)
	
	$PlayerHealthBar.max_value = Global.max_player_health
	$PlayerHealthBar.value = Global.player_health
	

func change_player_health():
	$PlayerHealthBar.value = Global.player_health
	$PlayerHealthBar/PlayerHealthLabel.text = str($PlayerHealthBar.value)
