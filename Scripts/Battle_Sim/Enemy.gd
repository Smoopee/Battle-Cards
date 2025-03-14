extends Node2D

const DECK_Y_POSITION = 100
const DECK_X_POSITION = 650
#==================================================================================================
const CARD_WIDTH = 130
const ENEMY_CARD_COLLISION_LAYER = 64
const HAND_Y_POSITION = 370

var enemy_cards_db = []
var enemy_inventory = []
#==================================================================================================

var center_screen_x
var center_screen_y
var discard_offset = 0
var enemy_deck = []
var enemy_skills = []
var enemy
var deck = []

var enemy_health_bar


func _ready():
	enemy = load(Global.current_enemy.enemy_scene_path).instantiate()
	add_child(enemy)
	center_screen_y = get_viewport().size.y / 2
	center_screen_x = get_viewport().size.x / 2
	enemy.position = Vector2(center_screen_x, 150)
	enemy.set_stats()
	
	enemy_health_bar = enemy.get_node("EnemyUI").get_node("EnemyHealthBar")
	enemy.get_node("EnemyUI").get_node("GoldAndXPBox").visible = false
	
	enemy_health_bar.max_value = Global.max_enemy_health
	enemy_health_bar.value = Global.enemy_health

func build_deck():
	if Global.enemy_active_deck == []:
		enemy_deck = enemy.enemy_deck
	else: 
		enemy_deck = Global.enemy_active_deck

	deck = []
	var counter = 0
	
	var card_position = 0
	for i in range(enemy_deck.size()):
		var new_card = load(enemy_deck[i].card_scene_path).instantiate()
		add_child(new_card)
		deck.push_back(new_card)
		new_card.card_stats = enemy_deck[i]
		new_card.upgrade_card(new_card.card_stats.upgrade_level)
		new_card.item_enchant(new_card.card_stats.item_enchant)
		new_card.card_stats.is_players = false
		new_card.card_stats.in_enemy_deck = true
		new_card.card_stats.deck_position = counter
		new_card.update_card_ui()
		
		counter += 1
	
	return deck

func build_deck_position():
	for i in deck:
		discard_offset = 0
		i.is_discarded = false
		i.scale =  Vector2(1, 1)
		i.position = Vector2(DECK_X_POSITION, DECK_Y_POSITION)
 
func play_card(card):
	if card.card_stats.deck_position < deck.size()-1:
		deck[card.card_stats.deck_position+1].z_index = 3
	animate_card_to_active_position(card)

func animate_card_to_active_position(card):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", Vector2(center_screen_x, center_screen_y - 150), 0.2)

func discard(card):
	card.is_discarded = true
	card.z_index = 1
	card.scale = Vector2(.55, .55)
	animate_card_to_discard_position(card)

func animate_card_to_discard_position(card):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", Vector2(1250 - discard_offset, 100), 0.1)
	discard_offset += 20

func add_skills():
	enemy_skills = enemy.enemy_skills
	
	var skill_array = []
	
	var skill_x_position = 0 
	for i in enemy_skills:
		var new_instance = i.instantiate()
		add_child(new_instance)
		new_instance.player_skill = false
		skill_array.push_back(new_instance)
		new_instance.position = Vector2(1400 + skill_x_position, 50)
		skill_x_position += 70
	return skill_array

func change_enemy_health():
	enemy_health_bar.value = Global.enemy_health
	enemy_health_bar.get_child(0).text = str(Global.enemy_health)

#==================================================================================================
func create_enemy_cards():
	fetch_enemy_cards()
	enemy_inventory = []

	for i in range(enemy_cards_db.size()):
		var card_scene = load(enemy_cards_db[i].card_scene_path).instantiate()
		card_scene.card_stats = enemy_cards_db[i]
		$"../NextTurn/DeckBuilder/EnemyCards".add_child(card_scene)
		add_card_to_hand(card_scene)
	
	var card_position = 0
	for i in enemy_inventory:
		i.upgrade_card(i.card_stats.upgrade_level)
		i.update_card_ui()
		i.get_node("Area2D").collision_mask = ENEMY_CARD_COLLISION_LAYER
		i.get_node("Area2D").collision_layer = ENEMY_CARD_COLLISION_LAYER
		i.card_stats.inventory_position = card_position
		i.card_stats.is_players = false
		card_position += 1

func fetch_enemy_cards():
	Global.enemy_active_deck.shuffle()
	enemy_cards_db = Global.enemy_active_deck
	

func add_card_to_hand(card):
	enemy_inventory.push_back(card)
	update_hand_positions()

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
