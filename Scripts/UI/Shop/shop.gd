extends Node2D

var save_file_path = "user://SaveData/"
var save_file_name = "PlayerSave.tres"
var playerData = PlayerData.new()
@onready var merchant_cards = $MerchantCards

@onready var player_inventory = $PlayerInventory
@onready var player_deck = $PlayerDeck

func _ready():
	verify_save_directory(save_file_path)
func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)
func save():
	ResourceSaver.save(playerData, save_file_path + save_file_name)
	print("save")


func _on_exit_button_button_down():
	inventory_and_deck_save()
	if Global.intermission_tracker <= 1: 
		Global.intermission_tracker += 1
		get_tree().change_scene_to_file("res://Scenes/UI/Intermission/intermission.tscn")
	else:
		Global.intermission_tracker = 0
		get_tree().change_scene_to_file("res://Scenes/UI/EnemySelection/enemy_selection.tscn")


func _on_reroll_button_button_down():
	if Global.player_gold < 5:
		print("Not enough gold")
		return
	merchant_cards.inventory = []
	
	for i in merchant_cards.get_children():
		if i.card_stats.is_players == false:
			merchant_cards.remove_child(i)
			i.queue_free()
	
	merchant_cards.inventory_db = []
	
	merchant_cards.create_merchant_inventory()

func inventory_and_deck_save():
	var temp_inventory = []
	for i in player_inventory.card_slot_reference:
		if i != null:
			temp_inventory.push_back(i.card_stats)
		else:
			temp_inventory.push_back(null)
	playerData.player_inventory = temp_inventory
	Global.player_inventory = temp_inventory

	var temp_deck = []
	for i in player_deck.card_slot_reference:
		if i != null:
			temp_deck.push_back(i.card_stats)
		else:
			temp_deck.push_back(null)
	playerData.player_deck = temp_deck
	Global.player_deck = temp_deck
	save()
