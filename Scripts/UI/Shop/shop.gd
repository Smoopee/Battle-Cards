extends Node2D

@onready var player_inventory = $Inventory

func _ready():
	var center_screen_x = get_viewport().size.x / 2
	$Player.position = Vector2(center_screen_x, 900)
	
	$Player.get_node("Area2D").collision_mask = 8
	$Player.get_node("Area2D").collision_layer = 8

func _on_exit_button_button_down():
	var inventory
	for i in player_inventory.inventory:
		var card = load(i.card_resource_path)
		inventory.push_back(i)
	Global.player_inventory = inventory
	get_tree().change_scene_to_file(("res://Scenes/UI/EnemySelection/enemy_selection.tscn"))
