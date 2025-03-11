extends Node2D

var save_file_path = "user://SaveData/"
var save_file_name = "PlayerSave.tres"
var playerData = PlayerData.new()
@onready var merchant_cards = $MerchantCards

@onready var player_inventory = $PlayerInventory

func _ready():
	verify_save_directory(save_file_path)
func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)
func save():
	ResourceSaver.save(playerData, save_file_path + save_file_name)
	print("save")


func _on_exit_button_button_down():
	var temp = []
	for i in player_inventory.inventory:
		temp.push_back(i.card_stats)
	playerData.player_inventory = temp
	Global.player_inventory = temp
	save()
	if Global.intermission_tracker <= 1: 
		Global.intermission_tracker += 1
		get_tree().change_scene_to_file("res://Scenes/UI/Intermission/intermission.tscn")
	else:
		Global.intermission_tracker = 0
		get_tree().change_scene_to_file("res://Scenes/UI/EnemySelection/enemy_selection.tscn")


func _on_reroll_button_button_down():
	merchant_cards.inventory = []
	
	for i in $CardManager.get_children():
		if i.card_stats.is_players == false:
			i.queue_free()
	
	merchant_cards.inventory_db = []
	
	merchant_cards.create_merchant_inventory()
