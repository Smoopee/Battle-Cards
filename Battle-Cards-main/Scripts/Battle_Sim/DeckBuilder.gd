extends Node2D
#
#var save_file_path = "user://SaveData/"
#var save_file_name = "PlayerSave.tres"
#var playerData = PlayerData.new()
#
#@onready var card_manager = $CardManager
#
#var deck = []
#
#func _ready():
	#verify_save_directory(save_file_path)
#
#func verify_save_directory(path: String):
	#DirAccess.make_dir_absolute(path)
#
#func save():
	#ResourceSaver.save(playerData, save_file_path + save_file_name)
	#print("save")
#
#func _on_button_button_down():
#
	#inventory_and_deck_save()
	#get_tree().change_scene_to_file(("res://Scenes/Battle/battle_sim.tscn"))
#
#func inventory_and_deck_save():
	#var blank = load("res://Resources/Cards/blank.tres")
	#
	#var temp_inventory = []
	#for i in card_manager.inventory_card_slot_reference:
		#if i != null:
			#temp_inventory.push_back(i.card_stats)
		#else:
			#temp_inventory.push_back(null)
	#playerData.player_inventory = temp_inventory
	#Global.player_inventory = temp_inventory
#
	#var temp_deck = []
	#for i in card_manager.deck_card_slot_reference:
		#if i != null:
			#temp_deck.push_back(i.card_stats)
		#else:
			#temp_deck.push_back(null)
	#playerData.player_deck = temp_deck
	#Global.player_deck = temp_deck
	#
	#Global.player_active_deck = []
	#
	#for i in Global.player_deck:
		#if i != null:
			#Global.player_active_deck.push_back(i.duplicate())
		#else:
			#Global.player_active_deck.push_back(blank)
	#save()
