extends Node2D


@onready var player_inventory = $PlayerInventoryScreen
var screen_size
var card_being_dragged


var is_toggle_inventory = false

func _ready():
	screen_size = get_viewport_rect().size
	toggle_inventory()

func _input(event):
	if event.is_action_pressed("Inventory"):
		toggle_inventory()

func inventory_and_deck_save():
	var temp_inventory = []
	for i in player_inventory.inventory_card_slot_reference:
		if i != null:
			temp_inventory.push_back(i.card_stats)
		else:
			temp_inventory.push_back(null)
	Global.player_inventory = temp_inventory

	var temp_deck = []
	for i in player_inventory.deck_card_slot_reference:
		if i != null:
			temp_deck.push_back(i.card_stats)
		else:
			temp_deck.push_back(null)
	Global.player_deck = temp_deck


func connect_card_signals(card):
	card.connect("hovered_on", on_hovered_over)
	card.connect("hovered_off", on_hovered_off)

func on_hovered_over(card):
	if $PlayerInventoryScreen.card_being_dragged and $PlayerInventoryScreen.hover_on_upgrade_test == true: return
	if $ConsumableManger.consumable_being_dragged: return
	card.mouse_exit = false
	card.scale = Vector2(1.1, 1.1)
	$TooltipTimer.start()
	await $TooltipTimer.timeout
	if card == null: return
	if card.mouse_exit or card_being_dragged: return
	card.toggle_tooltip_show()
	card.scale = Vector2(2, 2)
	card.z_index = 2

func on_hovered_off(card):
	if card_being_dragged: return
	card.mouse_exit = true
	card.toggle_tooltip_hide()
	card.scale = Vector2(1, 1)
	card.z_index = 1

func toggle_inventory():
	#From player screen to Inventory
	if is_toggle_inventory == true:
		$PlayerInventoryScreen.visible = true
		$Player/Berserker.inventory_screen_toggle(true)
		$PlayerInventoryScreen.process_mode = Node.PROCESS_MODE_INHERIT
		is_toggle_inventory = false
	#From Inventory to Player Screen
	else:
		$PlayerInventoryScreen.visible = false
		$Player/Berserker.inventory_screen_toggle(false)
		$PlayerInventoryScreen.process_mode = Node.PROCESS_MODE_DISABLED
		is_toggle_inventory = true


func _on_leave_button_down():
	Global.intermission_tracker = 0
	get_tree().change_scene_to_file("res://Scenes/UI/EnemySelection/enemy_selection.tscn")


func _on_rest_button_down():
	Global.rested_xp += 30
	get_tree().get_first_node_in_group("character").change_health(50)
	Global.intermission_tracker = 0
	get_tree().change_scene_to_file("res://Scenes/UI/EnemySelection/enemy_selection.tscn")

