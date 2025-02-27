extends Node2D

@onready var player_inventory = $Inventory

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_exit_button_button_down():
	get_tree().change_scene_to_file(("res://Scenes/UI/EnemySelection/enemy_selection.tscn"))
