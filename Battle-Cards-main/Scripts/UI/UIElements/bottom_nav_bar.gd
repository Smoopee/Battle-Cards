extends CanvasLayer

var screen = ""

var character_toggle = false
var inventory_toggle = false
var is_battling = false

func _ready() -> void:
	$ColorRect.size.x = get_viewport().size.x
	$ColorRect.size.y = 45
	$ColorRect.position.y = get_viewport().size.y - $ColorRect.size.y
	$ColorRect/PlayerUI.position.x += 50
	$ColorRect/HBoxContainer.position.x -= 100
	
func _on_talent_button_button_down():
	toggle_talent_screen()

func _on_character_button_down() -> void:
	if character_toggle == false: 
		if inventory_toggle == true: toggle_inventory(false)
		toggle_character(true)
	else:
		toggle_character(false)

func toggle_card_selection():
	hide_player_cards()
	hide_character()
	show_card_selector()
	show_player_health_bar()

func toggle_character(toggle):
	if is_battling: return
	if toggle == true:
		show_character()
		show_player_cards()
		show_deck()
		show_deck_slots()
		hide_inventory()
		if Global.current_scene == "intermission" or Global.current_scene ==  "enemy_selection": hide_card_selector()
		character_toggle = true
	else:
		character_toggle = false
		if Global.current_scene == "battle_sim" or  Global.current_scene == "shop": return
		hide_character()
		hide_player_cards()
		hide_deck()
		if Global.current_scene == "intermission" or Global.current_scene == "enemy_selection": show_card_selector()
		if Global.current_scene == "shop": show_character()


func _on_inventory_pressed() -> void:
	#get_parent().toggle_inventory()
	if inventory_toggle == false:
		if character_toggle == true: toggle_character(false)
		toggle_inventory(true)
	else:
		toggle_inventory(false)

func toggle_inventory(toggle):
	if is_battling: return
	if toggle == true:
		inventory_toggle = true
		show_player_cards()
		show_deck() 
		show_inventory()
		show_inventory_slots()
		show_deck_slots()
		hide_character()
		show_player_health_bar()
		if Global.current_scene == "intermission" or Global.current_scene == "enemy_selection": hide_card_selector()
		
	else:
		inventory_toggle = false
		if Global.current_scene == "battle_sim" or  Global.current_scene == "shop":
			show_character()
			hide_inventory()
			return
		hide_player_cards()
		hide_deck()
		hide_inventory()
		if Global.current_scene == "intermission" or Global.current_scene == "enemy_selection": show_card_selector()
		if Global.current_scene == "shop": show_character()

func toggle_combat_ui(toggle):
	if toggle:
		show_character()
		show_player_cards()
		hide_inventory_slots()
		hide_deck_slots()

func _on_back_button_button_down():
	if screen == "talents":
		get_tree().get_first_node_in_group("talent tree").visible = false
		$ColorRect/HBoxContainer/TalentButton.visible = true
		$ColorRect/HBoxContainer/MenuButton.visible = true
		$ColorRect/HBoxContainer/InventoryButton.visible = true
		$ColorRect/HBoxContainer/BackButton.visible = false
		
		screen = ""

func talent_alert_toggle(toggle):
	if toggle:
		$ColorRect/HBoxContainer/TalentButton/AlertIndicator.visible = true
	else: 
		$ColorRect/HBoxContainer/TalentButton/AlertIndicator.visible = false

func change_player_gold():
	$ColorRect/PlayerUI.change_player_gold()
	
func toggle_talent_screen():
	get_tree().get_first_node_in_group("talent tree").visible = true
	$ColorRect/HBoxContainer/TalentButton.visible = false
	$ColorRect/HBoxContainer/MenuButton.visible = false
	$ColorRect/HBoxContainer/InventoryButton.visible = false
	$ColorRect/HBoxContainer/BackButton.visible = true
	screen = "talents"

func hide_character():
	var character = get_tree().get_first_node_in_group("player")
	character.visible = false
	character.process_mode = Node.PROCESS_MODE_DISABLED

func show_character():
	var character = get_tree().get_first_node_in_group("player")
	get_tree().get_first_node_in_group("character").get_node("ClassImage").visible = true
	get_tree().get_first_node_in_group("character").get_node("RageBar").visible = true
	get_tree().get_first_node_in_group("character").get_node("StatContainer").visible = true
	get_tree().get_first_node_in_group("character").get_node("PlayerHealthBar").visible = true
	get_tree().get_first_node_in_group("character").get_node("ItemsUI").visible = true
	character.visible = true
	character.process_mode = Node.PROCESS_MODE_INHERIT

func hide_deck():
	var deck = get_tree().get_first_node_in_group("player deck")
	deck.visible = false
	deck.process_mode = Node.PROCESS_MODE_DISABLED

func show_deck():
	var deck = get_tree().get_first_node_in_group("player deck")
	deck.visible = true
	deck.process_mode = Node.PROCESS_MODE_INHERIT

func hide_inventory():
	var inventory = get_tree().get_first_node_in_group("player inventory")
	var inventory_slots = get_tree().get_first_node_in_group("player cards").get_node("InventorySlots")
	inventory.visible = false
	inventory.process_mode = Node.PROCESS_MODE_DISABLED
	inventory_slots.visible = false
	inventory_slots.process_mode = Node.PROCESS_MODE_DISABLED

func show_inventory():
	var inventory = get_tree().get_first_node_in_group("player inventory")
	var inventory_slots = get_tree().get_first_node_in_group("player cards").get_node("InventorySlots")
	inventory.visible = true
	inventory.process_mode = Node.PROCESS_MODE_INHERIT
	inventory_slots.visible = true
	inventory_slots.process_mode = Node.PROCESS_MODE_INHERIT

func show_player_cards():
	var player_cards = get_tree().get_first_node_in_group("player cards")
	player_cards.visible = true
	player_cards.process_mode = Node.PROCESS_MODE_INHERIT

func hide_player_cards():
	var player_cards = get_tree().get_first_node_in_group("player cards")
	player_cards.visible = false
	player_cards.process_mode = Node.PROCESS_MODE_DISABLED

func hide_card_selector():
	var card_selector = get_tree().get_first_node_in_group("card selector")
	card_selector.visible = false
	card_selector = Node.PROCESS_MODE_DISABLED

func show_card_selector():
	var card_selector = get_tree().get_first_node_in_group("card selector")
	card_selector.visible = true
	card_selector.process_mode = Node.PROCESS_MODE_INHERIT

func hide_inventory_slots():
	var inventory_slots = get_tree().get_first_node_in_group("player cards").get_node("InventorySlots")
	inventory_slots.visible = false
	inventory_slots.process_mode = Node.PROCESS_MODE_DISABLED

func show_inventory_slots():
	var inventory_slots = get_tree().get_first_node_in_group("player cards").get_node("InventorySlots")
	inventory_slots.visible = true
	inventory_slots.process_mode = Node.PROCESS_MODE_INHERIT

func hide_deck_slots():
	var deck_slots = get_tree().get_first_node_in_group("player cards").get_node("DeckCardSlots")
	deck_slots.visible = false
	deck_slots.process_mode = Node.PROCESS_MODE_DISABLED

func show_deck_slots():
	var deck_slots = get_tree().get_first_node_in_group("player cards").get_node("DeckCardSlots")
	deck_slots.visible = true
	deck_slots.process_mode = Node.PROCESS_MODE_INHERIT

func show_player_health_bar():
	get_tree().get_first_node_in_group("player").visible = true
	get_tree().get_first_node_in_group("character").get_node("ClassImage").visible = false
	get_tree().get_first_node_in_group("character").get_node("RageBar").visible = false
	get_tree().get_first_node_in_group("character").get_node("StatContainer").visible = false
	get_tree().get_first_node_in_group("character").get_node("PlayerHealthBar").visible = true
	get_tree().get_first_node_in_group("character").get_node("ItemsUI").visible = false

#func hide_player_health_bar():
	#get_tree().get_first_node_in_group("player").visible = true
	#get_tree().get_first_node_in_group("character").get_node("ClassImage").visible = false
	#get_tree().get_first_node_in_group("character").get_node("RageBar").visible = false
	#get_tree().get_first_node_in_group("character").get_node("PlayerHealthBar").visible = true


func _on_menu_button_down() -> void:
	get_tree().get_first_node_in_group("current scene").process_mode = Node.PROCESS_MODE_DISABLED
	get_tree().get_first_node_in_group("menu").visible = true
	get_tree().get_first_node_in_group("menu").process_mode = Node.PROCESS_MODE_INHERIT
