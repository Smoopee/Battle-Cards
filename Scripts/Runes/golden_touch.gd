extends Node2D

const ENEMY_CARD_COLLISION_LAYER = 64

var rune_stats: Runes_Resource = null
var rune_name = "Golden Touch"
var one_shot = true


func _ready():
	$PopupPanel/VBoxContainer/Name.text = rune_name
	update_tooltip("Effect","WIP", "Effect: ")

func connect_rune():
	if get_tree().get_first_node_in_group("enemy deck") != null:
		get_tree().get_first_node_in_group("enemy deck").connect("build_enemy_deck", rune_effect1)


	if get_tree().get_first_node_in_group("enemy") != null:
		if get_tree().get_first_node_in_group("enemy").has_signal("generate_reward"):
			get_tree().get_first_node_in_group("enemy").connect("generate_reward", reward)

func rune_effect1():
	if one_shot == false: return
	var enemy_deck = get_tree().get_first_node_in_group("enemy deck").deck
	var golden_touch_card = load("res://Scenes/Cards/golden_touch.tscn").instantiate().duplicate()
	var rng = RandomNumberGenerator.new()
	var rng_selection = rng.randi_range(0, enemy_deck.size()-1)
	
	get_tree().get_first_node_in_group("enemy deck").add_child(golden_touch_card)
	golden_touch_card.card_stats = load("res://Resources/Cards/golden_touch.tres")
	golden_touch_card.get_node("Area2D").collision_mask = ENEMY_CARD_COLLISION_LAYER
	golden_touch_card.get_node("Area2D").collision_layer = ENEMY_CARD_COLLISION_LAYER
	golden_touch_card.upgrade_card(golden_touch_card.card_stats.upgrade_level)
	golden_touch_card.card_stats.in_enemy_deck = true
	golden_touch_card.card_stats.card_owner = get_tree().get_first_node_in_group("enemy")
	golden_touch_card.card_stats.is_players = false
	
	var selected_card = enemy_deck[rng_selection]
	enemy_deck[rng_selection] = golden_touch_card
	golden_touch_card.card_stats.deck_position = selected_card.card_stats.deck_position
	get_tree().get_first_node_in_group("enemy deck").update_hand_positions()
	selected_card.queue_free()
	
	one_shot = false

func reward():
	pass

func toggle_tooltip_show():
	if $PopupPanel/VBoxContainer.get_children() == []: return
	$PopupPanel.popup(Rect2i(global_position + Vector2(20, -70), Vector2(0, 0)))

func toggle_tooltip_hide():
	$PopupPanel.hide()

func update_tooltip(identifier, body = null, header = null,):
	var tooltip
	for i in $PopupPanel/VBoxContainer.get_children():
		if i.name == identifier: 
			tooltip = i

	if tooltip == null:
		var hbox = HBoxContainer.new()
		hbox.name = identifier
		$PopupPanel/VBoxContainer.add_child(hbox)
		var name_label = Label.new()
		hbox.add_child(name_label)
		name_label.add_theme_color_override("font_color", Color.BLACK)
		name_label.text = str(header)
		var body_label = Label.new()
		hbox.add_child(body_label)
		body_label.add_theme_color_override("font_color", Color.BLACK)
		body_label.text = str(body)
	
	else:
		tooltip.get_child(1).text = str(body)

func rune_shop_ui():
	if rune_stats.rune_owner != get_tree().get_first_node_in_group("character"):
		$RuneUI/ShopPanel/ShopLabel.text =  str(rune_stats.buy_price)

func toggle_shop_ui(show):
	if show: $RuneUI/ShopPanel.visible = true
	if Global.current_scene == "shop": return
	if !show: $RuneUI/ShopPanel.visible = false




