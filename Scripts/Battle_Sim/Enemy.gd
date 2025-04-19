extends Node2D

signal build_enemy_deck

const DECK_Y_POSITION = 215
const DECK_X_POSITION = 600
const ENEMY_Y_POSITION = 180
#==================================================================================================
const CARD_WIDTH = 160
const ENEMY_CARD_COLLISION_LAYER = 64
const HAND_Y_POSITION = 380

var enemy_cards_db = []
var enemy_inventory = []
#==================================================================================================

var center_screen_x
var center_screen_y
var discard_offset = 0
var deck_offset = 0
var enemy_deck = []
var enemy
var deck = []



func _ready():
	enemy = load(Global.current_enemy.enemy_scene_path).instantiate()
	add_child(enemy)
	enemy.character_stats = Global.current_enemy
	enemy.setup()
	center_screen_y = get_viewport().size.y / 2
	center_screen_x = get_viewport().size.x / 2
	enemy.position = Vector2(center_screen_x, ENEMY_Y_POSITION)
	enemy.set_stats()
	
	enemy.get_node("EnemyUI").get_node("GoldAndXPBox").visible = false

func initial_build_deck():
	enemy_deck = enemy.deck

	deck = []
	var card_position = 0
	var blank = load("res://Resources/Cards/blank.tres")
	for i in range(enemy_deck.size()):
		if enemy_deck[i] == null:
			var load_blank = load("res://Scenes/Cards/blank_card.tscn").instantiate()
			load_blank.card_stats = blank
			load_blank.card_stats.deck_position = card_position
			load_blank.card_stats.owner = get_tree().get_first_node_in_group("enemy")
			load_blank.card_stats.is_players = true
			deck.push_back(load_blank)
			add_child(load_blank)
		else:
			var new_card = load(enemy_deck[i].card_scene_path).instantiate()
			add_child(new_card)
			deck.push_back(new_card)
			new_card.card_stats = enemy_deck[i]
			new_card.upgrade_card(new_card.card_stats.upgrade_level)
			new_card.item_enchant(new_card.card_stats.item_enchant)
			new_card.card_stats.is_players = false
			new_card.card_stats.owner = get_tree().get_first_node_in_group("enemy")
			new_card.card_stats.target = get_tree().get_first_node_in_group("character")
			new_card.card_stats.in_enemy_deck = true
			new_card.card_stats.deck_position = card_position
			new_card.update_card_ui()
		
		card_position += 1
	return deck

func build_deck_position():
	discard_offset = 0
	deck_offset = 0
	var temp_z_index = 13
	for i in deck:
		i.is_discarded = false
		i.scale =  Vector2(1, 1)
		i.position = Vector2(DECK_X_POSITION + deck_offset, DECK_Y_POSITION)
		i.z_index = temp_z_index
		deck_offset -= 40
		temp_z_index -= 1

func play_card(card):
	animate_card_to_active_position(card)

func animate_card_to_active_position(card):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", Vector2(center_screen_x, center_screen_y - 150), 0.2 * Global.COMBAT_SPEED)

func discard(card):
	card.is_discarded = true
	card.z_index = card.card_stats.deck_position
	card.scale = Vector2(.55, .55)
	animate_card_to_discard_position(card)

func animate_card_to_discard_position(card):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", Vector2(1450 - discard_offset, 200), 0.1 * Global.COMBAT_SPEED)
	discard_offset += 20


#==================================================================================================
func build_deck():
	var blank = load("res://Resources/Cards/blank.tres")
	enemy_inventory = []
	
	for i in get_children():
		if i.is_in_group("card"):
			enemy_inventory.push_back(i)
	
	enemy_inventory.shuffle()

	var card_position = 0
	for i in enemy_inventory:
		if i == null:
			var load_blank = load("res://Scenes/Cards/blank_card.tscn").instantiate()
			load_blank.card_stats = blank
			load_blank.card_stats.deck_position = card_position
			load_blank.card_stats.owner = get_tree().get_first_node_in_group("enemy")
			load_blank.card_stats.is_players = false
			deck.push_back(load_blank)
			add_child(load_blank)
		else:
			i.get_node("Area2D").collision_mask = ENEMY_CARD_COLLISION_LAYER
			i.get_node("Area2D").collision_layer = ENEMY_CARD_COLLISION_LAYER
			i.enable_collision()
			i.card_stats.deck_position = card_position
			i.card_stats.is_players = false
			i.scale = Vector2(1,1)
			update_hand_positions()
		
		card_position += 1

	deck = enemy_inventory
	emit_signal("build_enemy_deck")
	
	return enemy_inventory

func update_hand_positions():
	for i in range(enemy_inventory.size()):
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		var card = enemy_inventory[i]
		card.card_stats.screen_position = new_position
		card.position = new_position

func calculate_card_position(index):
	var total_width = (enemy_inventory.size() - 1) * CARD_WIDTH
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2
	return x_offset

func enemy_reward():
	return enemy.get_reward()
