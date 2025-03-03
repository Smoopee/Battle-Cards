extends Node2D

var save_file_path = "user://SaveData/"
var save_file_name = "PlayerSave.tres"
var playerData = PlayerData.new()

@onready var player_inventory = $Inventory

func _ready():
	verify_save_directory(save_file_path)
	var center_screen_x = get_viewport().size.x / 2
	$Player.position = Vector2(center_screen_x, 900)
	
	$Player.get_node("Area2D").collision_mask = 8
	$Player.get_node("Area2D").collision_layer = 8
	

func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)
func save():
	ResourceSaver.save(playerData, save_file_path + save_file_name)
	print("save")


func _on_exit_button_button_down():
	var temp = []
	for i in player_inventory.inventory:
		temp.push_back(i.card_resource)
	playerData.player_inventory = temp
	Global.player_inventory = temp
	save()
	get_tree().change_scene_to_file(("res://Scenes/UI/EnemySelection/enemy_selection.tscn"))


