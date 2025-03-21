extends Node2D


@onready var card_manager = $CardManager

var deck = []
var deck_builder_screen = true
var current_screen = ""

func _ready():
	var enemy = Global.current_enemy

func _input(event):
	if event.is_action_pressed("Inventory"):
		toggle_inventory()


func _on_button_button_down():
	inventory_and_deck_save()
	Global.save_function()
	load_battle_sim()

func inventory_and_deck_save():
	var blank = load("res://Resources/Cards/blank.tres")
	
	var temp_inventory = []
	for i in card_manager.inventory_card_slot_reference:
		if i != null:
			temp_inventory.push_back(i.card_stats)
		else:
			temp_inventory.push_back(null)
	Global.player_inventory = temp_inventory

	var temp_deck = []
	for i in card_manager.deck_card_slot_reference:
		if i != null:
			temp_deck.push_back(i.card_stats)
		else:
			temp_deck.push_back(null)
	Global.player_deck = temp_deck
	
	Global.player_active_deck = []
	for i in Global.player_deck:
		if i != null:
			Global.player_active_deck.push_back(i.duplicate())
		else:
			Global.player_active_deck.push_back(blank)
	
	Global.player_active_inventory = []
	for i in Global.player_inventory:
		if i != null:
			Global.player_active_inventory.push_back(i.duplicate())
		else:
			Global.player_active_inventory.push_back(null)

func load_battle_sim():
	var player_class = Global.player_class
	match player_class:
		"berserker":
			get_tree().change_scene_to_file(("res://Scenes/Battle/berserker_battle_sim.tscn"))

func _on_talent_button_button_down():
	$TalentTree.visible = true
	deck_builder_screen = false
	$CanvasLayer/ColorRect/HBoxContainer/TalentButton.visible = false
	$CanvasLayer/ColorRect/HBoxContainer/MenuButton.visible = false
	$CanvasLayer/ColorRect/HBoxContainer/BackButton.visible = true
	current_screen = "talents"

func _on_back_button_button_down():
	match(current_screen):
		"talents":
			$TalentTree.visible = false

	$CanvasLayer/ColorRect/HBoxContainer/TalentButton.visible = true
	$CanvasLayer/ColorRect/HBoxContainer/MenuButton.visible = true
	$CanvasLayer/ColorRect/HBoxContainer/BackButton.visible = false
	deck_builder_screen = true

func toggle_inventory():
	if $PlayerInventory.visible == false:
		$InventorySlots.visible = true
		$PlayerInventory.visible = true
		$Player.visible = false
		for i in $CardManager.inventory_card_slot_reference:
			if i == null: continue
			i.visible = true
			i.enable_collision()
		$InventorySlots.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		$PlayerInventory.visible = false
		$InventorySlots.visible = false
		$Player.visible = true
		for i in $CardManager.inventory_card_slot_reference:
			if i == null: continue
			i.visible = false
			i.disable_collision()
		$InventorySlots.process_mode = Node.PROCESS_MODE_DISABLED

