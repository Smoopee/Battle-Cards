extends Node2D

var rng = RandomNumberGenerator.new()

var enemy_deck = []
var card_selection = []

var card_db_reference
var difficulty

func _ready():
	card_db_reference = preload("res://Resources/Cards/card_db.gd")
	difficulty = $"..".set_difficulty()
	get_card_selection()
	create_deck()


func get_card_selection():
	match difficulty:
		1:
			for i in card_db_reference.ITEMS:
				var temp = load(card_db_reference.ITEMS[i])
				for j in temp.tags:
					if j == "Rats" and temp.card_rarity <= 1:
						card_selection.push_back(temp)
		2:
			for i in card_db_reference.ITEMS:
				var temp = load(card_db_reference.ITEMS[i])
				for j in temp.tags:
					if j == "Rats" and temp.card_rarity <= 2:
						card_selection.push_back(temp)
		3:
			for i in card_db_reference.ITEMS:
				var temp = load(card_db_reference.ITEMS[i])
				for j in temp.tags:
					if j == "Rats" and temp.card_rarity <= 2:
						card_selection.push_back(temp)
		4:
			for i in card_db_reference.ITEMS:
				var temp = load(card_db_reference.ITEMS[i])
				for j in temp.tags:
					if j == "Rats" and temp.card_rarity <= 3:
						card_selection.push_back(temp)
		_:
			for i in card_db_reference.ITEMS:
				var temp = load(card_db_reference.ITEMS[i])
				for j in temp.tags:
					if j == "Rats" and temp.card_rarity <= 4:
						card_selection.push_back(temp)

func create_deck():
	for i in range(0, 10):
		var selection = random_card_selection().duplicate()
		enemy_deck.push_front(selection)
	
	card_upgrade_function()
	card_enchantment_function()

func random_card_selection():
	var card_selection_index = rng.randi_range(0, card_selection.size()-1)
	return card_selection[card_selection_index]

func card_upgrade_function():
	
	match difficulty:
		1:
			for i in enemy_deck:
				i.upgrade_level = 1
		2:
			for i in enemy_deck:
				var upgrade_calc = rng.randi_range(0, 99)
				if upgrade_calc >= 70: i.upgrade_level = 2
				elif upgrade_calc >= 0: i.upgrade_level = 1
		3:
			for i in enemy_deck:
				var upgrade_calc = rng.randi_range(0, 99)
				if upgrade_calc >= 90: i.upgrade_level = 3
				elif upgrade_calc >= 60: i.upgrade_level = 2
				elif upgrade_calc >= 0: i.upgrade_level = 1
		4:
			for i in enemy_deck:
				var upgrade_calc = rng.randi_range(0, 99)
				if upgrade_calc >= 99: i.upgrade_level = 4
				elif upgrade_calc >= 70: i.upgrade_level = 3
				elif upgrade_calc >= 30: i.upgrade_level = 2
				elif upgrade_calc >= 0: i.upgrade_level = 1
		_:
			for i in enemy_deck:
				var upgrade_calc = rng.randi_range(0, 99)
				if upgrade_calc >= 95: i.upgrade_level = 4
				elif upgrade_calc >= 50: i.upgrade_level = 3
				elif upgrade_calc >= 0: i.upgrade_level = 2

func card_enchantment_function():
	match difficulty:
		1:
			return
		2:
			return
		3:
			for i in enemy_deck:
				var enchant_calc = rng.randi_range(0, 99)
				if enchant_calc >= 98: i.item_enchant = "Bleed"
		4:
			for i in enemy_deck:
				var enchant_calc = rng.randi_range(0, 99)
				if enchant_calc >= 90: i.item_enchant = "Bleed"
		_:
			for i in enemy_deck:
				var enchant_calc = rng.randi_range(0, 99)
				if enchant_calc >= 80: i.item_enchant = "Bleed"



