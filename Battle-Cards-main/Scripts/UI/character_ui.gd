extends CanvasLayer

var screen = ""

var inventory_toggle = false
var is_battling = false

func _ready():
	pass
#
#func toggle_card_selection():
	#hide_player_cards()
	#hide_character()
	#show_card_selector()
	#show_player_health_bar()


func toggle_inventory(toggle):
	var start_pos = get_tree().get_first_node_in_group("player cards").get_node("InventorySlots").get_child(0)
	$Inventory.global_position = start_pos.global_position + Vector2(100, -60)
	if is_battling: return
	if toggle == true:
		$Inventory.text = "Character"
		show_player_cards()
		show_deck() 
		show_side_deck()
		show_player_side_deck_slots()
		show_inventory_slots()
		show_deck_slots()
		hide_character()
		show_player_health_bar()
		
	else:
		#$Inventory.position = Vector2(Global.center_screen_x + 105, 810)
		$Inventory.text = "Inventory"
		show_character()
		hide_player_side_deck_slots()
		hide_side_deck()
		

func toggle_combat_ui(toggle):
	if toggle:
		show_character()
		show_player_cards()
		hide_inventory_slots()
		hide_deck_slots()

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
	get_tree().get_first_node_in_group("character").get_node("PlayerSkills").visible = true
	get_tree().get_first_node_in_group("character").get_node("PlayerInterrupts").visible = true
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

func hide_side_deck():
	var side_deck = get_tree().get_first_node_in_group("player inventory")
	side_deck.visible = false
	side_deck.process_mode = Node.PROCESS_MODE_DISABLED

func show_side_deck():
	var side_deck = get_tree().get_first_node_in_group("player inventory")
	side_deck.visible = true
	side_deck.process_mode = Node.PROCESS_MODE_INHERIT

func show_player_cards():
	var player_cards = get_tree().get_first_node_in_group("player cards")
	player_cards.visible = true
	player_cards.process_mode = Node.PROCESS_MODE_INHERIT

func hide_player_cards():
	var player_cards = get_tree().get_first_node_in_group("player cards")
	player_cards.visible = false
	player_cards.process_mode = Node.PROCESS_MODE_DISABLED

func hide_player_side_deck_slots():
	var side_deck_slots = get_tree().get_first_node_in_group("player cards").get_node("InventorySlots")
	side_deck_slots.visible = false
	side_deck_slots.process_mode = Node.PROCESS_MODE_DISABLED

func show_player_side_deck_slots():
	var side_deck_slots = get_tree().get_first_node_in_group("player cards").get_node("InventorySlots")
	side_deck_slots.visible = true
	side_deck_slots.process_mode = Node.PROCESS_MODE_INHERIT
	
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
	get_tree().get_first_node_in_group("character").get_node("PlayerSkills").visible = false
	get_tree().get_first_node_in_group("character").get_node("BlockSymbol").visible = false
	get_tree().get_first_node_in_group("character").get_node("PlayerConsumables").visible = false
	get_tree().get_first_node_in_group("character").get_node("PlayerRunes").visible = false
	get_tree().get_first_node_in_group("character").get_node("PlayerInterrupts").visible = false
	

#func hide_player_health_bar():
	#get_tree().get_first_node_in_group("player").visible = true
	#get_tree().get_first_node_in_group("character").get_node("ClassImage").visible = false
	#get_tree().get_first_node_in_group("character").get_node("RageBar").visible = false
	#get_tree().get_first_node_in_group("character").get_node("PlayerHealthBar").visible = true


func _on_inventory_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		toggle_inventory(true)
	else:
		toggle_inventory(false)
