extends Node

const COMBAT_SPEED = .7


signal level_up

var save_file_path = "user://SaveData/"
var save_file_name = "PlayerSave.tres"
var playerData = PlayerData.new()

@onready var player_level: int 
@onready var player_gold: int
@onready var player_xp: int = 0
@onready var xp_threshold = 10


@onready var player_deck = []
@onready var player_skills = []
@onready var player_consumables = []
@onready var player_runes = []
@onready var player_inventory_db = []
@onready var player_deck_db
@onready var player_skills_db
@onready var player_consumables_db
@onready var player_runes_db
@onready var player_inventory = []
@onready var player_talent_array = []
@onready var player_stats
@onready var player_class = ""
var rested_xp = 0

@onready var current_merchant = "res://Scenes/Merchants/grack.tscn"
@onready var current_enemy = load("res://Resources/Enemies/Trogg.tres")
@onready var enemy_active_deck = []

var intermission_tracker = 0
var battle_tracker = 1
var current_scene = ""

var skill_db_reference
var card_db_reference
var rune_db_reference
var consumable_db_reference
var card_node_reference = 3


var mouse_occupied = false


func _ready():
	card_db_reference = preload("res://Resources/Cards/card_db.gd")
	skill_db_reference = preload("res://Resources/Skills/skill_db.gd")
	consumable_db_reference = preload("res://Resources/Consumables/consumable_db.gd")
	rune_db_reference = preload("res://Resources/Runes/rune_db.gd")
	
	set_player_skills()
	instantiate_player_skills()
	set_player_consumables()
	instantiate_player_consumables()
	set_player_runes()
	instantiate_player_runes()
	
	load_data()
	load_function()
	
	if player_inventory == null:
		instantiate_player_deck()
		instantiate_player_inventory()
		instantiate_player_skills()

func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)

func save():
	ResourceSaver.save(playerData, save_file_path + save_file_name)
	print("save")

func gain_xp(amount):
	if rested_xp > 0:
		if rested_xp >= amount:
			amount *= 2
			rested_xp -= amount
		else:
			amount += rested_xp
			rested_xp = 0

	player_xp += amount
	while player_xp >= xp_threshold:
		player_xp -= xp_threshold
		player_level += 1
		emit_signal("level_up")

func set_player_inventory():
	player_inventory_db = []

func instantiate_player_inventory():
	for i in player_inventory_db:
		var card = load(card_db_reference.CARDS[i]).duplicate()
		card.is_players = true
		player_inventory.push_back(card)

func set_player_deck():
	player_deck_db = ["Strike", "Strike", 
	"Strike", "Strike", "Strike", "Strike", "Strengthen", "Rock"]

func instantiate_player_deck():
	for i in player_deck_db:
		var card = load(card_db_reference.CARDS[i]).duplicate()
		card.is_players = true
		player_deck.push_back(card)

func set_player_skills():
	player_skills_db = ["Third Wheel", "Building Momentum"]

func instantiate_player_skills():
	for i in player_skills_db:
		var skill = load(skill_db_reference.SKILLS[i]).duplicate()
		player_skills.push_back(skill)

func set_player_consumables():
	player_consumables_db = ["Health Potion", "Glue", "Strength Potion"]

func instantiate_player_consumables():
	for i in player_consumables_db:
		var consumable = load(consumable_db_reference.CONSUMABLES[i]).duplicate()
		player_consumables.push_back(consumable)

func set_player_runes():
	player_runes_db = []

func instantiate_player_runes():
	for i in player_runes_db:
		var rune = load(rune_db_reference.RUNES[i]).duplicate()
		player_runes.push_back(rune)

func load_data():
	playerData = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)
	print("loaded")

func save_function():
	playerData.player_class = player_class
	playerData.player_deck = player_deck
	playerData.player_inventory = player_inventory
	playerData.player_talent_array = player_talent_array
	playerData.player_gold = player_gold
	playerData.player_xp = player_xp
	playerData.player_level = player_level
	playerData.battle_tracker = battle_tracker
	playerData.player_skills = player_skills
	playerData.player_consumables = player_consumables
	playerData.player_runes = player_runes
	playerData.player_stats = player_stats

	save()

func load_function():
	player_inventory = playerData.player_inventory
	player_deck = playerData.player_deck
	player_talent_array = playerData.player_talent_array
	player_class = playerData.player_class
	player_gold = playerData.player_gold
	player_xp = playerData.player_xp
	player_level = playerData.player_level
	battle_tracker = playerData.battle_tracker
	player_skills = playerData.player_skills
	player_consumables = playerData.player_consumables
	player_runes = playerData.player_runes
	player_stats = playerData.player_stats

