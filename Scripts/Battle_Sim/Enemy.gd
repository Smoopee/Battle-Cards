extends Node2D

var enemy_deck = []
var enemy_skills = []
var enemy


func _ready():
	enemy = load(Global.current_enemy.enemy_scene_path).instantiate()
	add_child(enemy)
	
	var center_screen_x = get_viewport().size.x / 2
	enemy.position = Vector2(center_screen_x, 150)
	
func build_deck():
	enemy_deck = enemy.enemy_deck

	var deck = []
	var counter = 0
	
	var card = preload("res://Scenes/UI/card.tscn")
	var card_position = 0
	for i in range(enemy_deck.size()):
		var card_scene = card
		var new_card = card_scene.instantiate()
		new_card.get_node("CardImage").texture = load(enemy_deck[i].card_art_path)
		new_card.visible = false
		add_child(new_card)
		deck.push_back(new_card)
		var new_node = load(enemy_deck[i].card_scene_path).instantiate()
		#     it is i+1 to get the current card to attach the Node 
		get_child(i+1).add_child(new_node)
		new_node.visible = false
		new_card.card_resource = enemy_deck[i]
		new_node.upgrade_card(enemy_deck[i].upgrade_level)
		new_card.card_resource = enemy_deck[i].duplicate()
		new_card.card_resource.is_players = false
		new_card.card_resource.in_enemy_deck = true
		
		counter += 1
	
	return deck

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

