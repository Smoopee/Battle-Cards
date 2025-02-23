extends Node2D



func _on_button_button_down():
	
	get_tree().change_scene_to_file(("res://Scenes/UI/Intermission/intermission.tscn"))
