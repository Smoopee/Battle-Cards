extends Node2D


var enemy_active_effects = []
var enemy_remove_effects = []
var player_active_effects = []
var player_remove_effects = []
var player_active_cards
var enemy_active_cards

func _ready():
	get_tree().get_first_node_in_group("player cards").connect("card_moved", on_card_move)
	get_tree().get_first_node_in_group("battle sim").connect("end_fight", disconnect_signals)
	player_active_cards = get_tree().get_first_node_in_group("player cards").deck_card_slot_reference.duplicate()
	set_up_arrays()

func disconnect_signals():
	get_tree().get_first_node_in_group("player cards").disconnect("card_moved", on_card_move)

func reset_active_spots():
	player_active_effects = []
	player_remove_effects = []
	enemy_active_effects = []
	enemy_remove_effects = []
	set_up_arrays()

func on_card_move():
	remove_active_effects()
	player_active_cards = get_tree().get_first_node_in_group("player cards").deck_card_slot_reference.duplicate()

	apply_active_effects()

func remove_active_effects():
	var counter = 0
	for i in player_remove_effects:
		if i != []:
			for j in range(0, i.size()):
				i[j].call(player_active_cards[counter])
		counter += 1
	
	counter = 0
	for i in enemy_remove_effects:
		if i != []:
			for j in range(0, i.size()):
				i[j].call(enemy_active_cards[counter])
		counter += 1

func add_to_active_effects(spot, effect, target):
	if target.is_in_group("character"):
		player_active_effects[spot].append(effect)
	elif target.is_in_group("enemy"):
		enemy_active_effects[spot].append(effect)

func add_to_remove_effects(spot, effect, target):
	if target.is_in_group("character"):
		player_remove_effects[spot].append(effect)
	elif target.is_in_group("enemy"):
		enemy_remove_effects[spot].append(effect)

func apply_active_effects():
	enemy_active_cards = get_tree().get_first_node_in_group("enemy deck").deck.duplicate()
	var counter = 0
	for i in player_active_effects:
		if i != []:
			for j in range(0, i.size()):
				i[j].call(player_active_cards[counter])
		counter += 1
		
	counter = 0
	for i in enemy_active_effects:
		if i != []:
			for j in range(0, i.size()):
				i[j].call(enemy_active_cards[counter])
		counter += 1

func set_up_arrays():
	enemy_active_cards = get_tree().get_first_node_in_group("enemy deck").deck.duplicate()
	var player_callable1 : Array[Callable] = []
	var player_callable2 : Array[Callable] = []
	var player_callable3 : Array[Callable] = []
	var player_callable4 : Array[Callable] = []
	var player_callable5 : Array[Callable] = []
	var player_callable6 : Array[Callable] = []
	var player_callable7 : Array[Callable] = []
	
	player_active_effects.push_back(player_callable1)
	player_active_effects.push_back(player_callable2)
	player_active_effects.push_back(player_callable3)
	player_active_effects.push_back(player_callable4)
	player_active_effects.push_back(player_callable5)
	player_active_effects.push_back(player_callable6)
	player_active_effects.push_back(player_callable7)
	
	var player_callable11 : Array[Callable] = []
	var player_callable12 : Array[Callable] = []
	var player_callable13 : Array[Callable] = []
	var player_callable14 : Array[Callable] = []
	var player_callable15 : Array[Callable] = []
	var player_callable16 : Array[Callable] = []
	var player_callable17 : Array[Callable] = []
	
	player_remove_effects.push_back(player_callable11)
	player_remove_effects.push_back(player_callable12)
	player_remove_effects.push_back(player_callable13)
	player_remove_effects.push_back(player_callable14)
	player_remove_effects.push_back(player_callable15)
	player_remove_effects.push_back(player_callable16)
	player_remove_effects.push_back(player_callable17)
	
	var enemy_callable1 : Array[Callable] = []
	var enemy_callable2 : Array[Callable] = []
	var enemy_callable3 : Array[Callable] = []
	var enemy_callable4 : Array[Callable] = []
	var enemy_callable5 : Array[Callable] = []
	var enemy_callable6 : Array[Callable] = []
	var enemy_callable7 : Array[Callable] = []
	
	enemy_active_effects.push_back(enemy_callable1)
	enemy_active_effects.push_back(enemy_callable2)
	enemy_active_effects.push_back(enemy_callable3)
	enemy_active_effects.push_back(enemy_callable4)
	enemy_active_effects.push_back(enemy_callable5)
	enemy_active_effects.push_back(enemy_callable6)
	enemy_active_effects.push_back(enemy_callable7)
	
	var enemy_callable11 : Array[Callable] = []
	var enemy_callable12 : Array[Callable] = []
	var enemy_callable13 : Array[Callable] = []
	var enemy_callable14 : Array[Callable] = []
	var enemy_callable15 : Array[Callable] = []
	var enemy_callable16 : Array[Callable] = []
	var enemy_callable17 : Array[Callable] = []
	
	enemy_remove_effects.push_back(enemy_callable11)
	enemy_remove_effects.push_back(enemy_callable12)
	enemy_remove_effects.push_back(enemy_callable13)
	enemy_remove_effects.push_back(enemy_callable14)
	enemy_remove_effects.push_back(enemy_callable15)
	enemy_remove_effects.push_back(enemy_callable16)
	enemy_remove_effects.push_back(enemy_callable17)
