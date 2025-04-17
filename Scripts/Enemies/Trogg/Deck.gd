extends Node2D

var rng = RandomNumberGenerator.new()

var enemy_deck = []
var card_selection = []

var card_db_reference

func _ready():
	card_db_reference = preload("res://Resources/Cards/card_db.gd")
	var difficulty = set_difficulty()
	get_card_selection()
	create_deck()

func get_card_selection():
	for i in card_db_reference.CARDS:
		var temp = load(card_db_reference.CARDS[i])
		for j in temp.tags:
			if j == "Trogg":
				card_selection.push_back(temp)

func create_deck():
	for i in range(0, 10):
		var selection = random_card_selection().duplicate()
		enemy_deck.push_front(selection)
	
	card_upgrade_function()

func random_card_selection():
	var card_selection_index = rng.randi_range(0, card_selection.size()-1)
	return card_selection[card_selection_index]

func card_upgrade_function():
	for i in enemy_deck:
		var upgrade_calc = rng.randi_range(0, 99)
		if upgrade_calc >= 96: i.upgrade_level = 4
		elif upgrade_calc >= 69: i.upgrade_level = 3
		elif upgrade_calc >= 49: i.upgrade_level = 2
		elif upgrade_calc >= 0: i.upgrade_level = 1


func set_difficulty():
	var battle_number = Global.battle_tracker
	
	if battle_number >= 4:
		return 1
	elif battle_number >= 8:
		return 2
	elif battle_number >= 12:
		return 3
	elif battle_number >= 16:
		return 4
	else: return 5
