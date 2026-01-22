extends Node2D


@onready var player_inventory = $PlayerInventoryScreen
var screen_size
var card_being_dragged

var is_toggle_inventory = false

func _ready():
	screen_size = get_viewport_rect().size
	toggle_inventory()
	player_inventory.toggle_sell_zone(true)
	$RewardSelection.reward_selection()

#func _process(delta):
	#if card_being_dragged:
		#var mouse_pos = get_global_mouse_position()
		#card_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), 
			#clamp(mouse_pos.y, 0, screen_size.y))

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

#func connect_card_signals(card):
	#card.connect("hovered_on", on_hovered_over)
	#card.connect("hovered_off", on_hovered_off)

#func on_hovered_over(card):
	#if $PlayerInventoryScreen.card_being_dragged and $PlayerInventoryScreen.hover_on_upgrade_test == true: return
	#if $ConsumableManger.consumable_being_dragged: return
	#card.mouse_exit = false
	#card.scale = Vector2(1.1, 1.1)
	#$TooltipTimer.start()
	#await $TooltipTimer.timeout
	#if card == null: return
	#if card.mouse_exit or card_being_dragged: return
	#card.toggle_tooltip_show()
	#card.scale = Vector2(2, 2)
	#card.z_index = 2
#
#func on_hovered_off(card):
	#if card_being_dragged: return
	#card.mouse_exit = true
	#card.toggle_tooltip_hide()
	#card.scale = Vector2(1, 1)
	#card.z_index = 1

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

func _on_continue_button_down():
	Global.current_scene = "intermission"
	inventory_and_deck_save()
	Global.player_consumables = get_tree().get_first_node_in_group("player consumables").get_consumable_array()
	Global.player_runes = get_tree().get_first_node_in_group("player runes").get_rune_array()
	Global.save_function()
	await get_tree().get_first_node_in_group("main").scene_transition(1, 1.0)
	get_parent().add_scene("res://Scenes/UI/Intermission/intermission.tscn")
	queue_free()
