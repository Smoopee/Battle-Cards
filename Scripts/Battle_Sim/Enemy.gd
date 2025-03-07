extends Node2D

const DECK_Y_POSITION = 100
const DECK_X_POSITION = 650

var center_screen_x
var center_screen_y
var discard_offset = 0

var enemy_deck = []
var enemy_skills = []
var enemy
var deck = []

func _ready():
	enemy = load(Global.current_enemy.enemy_scene_path).instantiate()
	add_child(enemy)
	center_screen_y = get_viewport().size.y / 2
	center_screen_x = get_viewport().size.x / 2
	enemy.position = Vector2(center_screen_x, 150)
	
	get_child(0).get_node("EnemyHealthBar").max_value = Global.max_enemy_health
	get_child(0).get_node("EnemyHealthBar").value = Global.enemy_health
	
func build_deck():
	enemy_deck = enemy.enemy_deck

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
	print("Skill array is " + str(enemy_skills))
	
	var skill_x_position = 0 
	for i in enemy_skills:
		var new_instance = i.instantiate()
		add_child(new_instance)
		print("This new skill is added! " + str(i))
		new_instance.player_skill = false
		skill_array.push_back(new_instance)
		new_instance.position = Vector2(1400 + skill_x_position, 50)
		skill_x_position += 70
		

	return skill_array

func change_enemy_health():
	get_child(0).get_node("EnemyHealthBar").value = Global.enemy_health
