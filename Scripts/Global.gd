extends Node

const COMBAT_SPEED = 1

var save_file_path = "user://SaveData/"
var save_file_name = "PlayerSave.tres"
var playerData = PlayerData.new()

@onready var player_health: int
@onready var max_player_health: int

@onready var player_level: int = 1
@onready var player_gold: int
@onready var player_xp: int = 0
@onready var xp_threshold = 30

@onready var enemy_health: int
@onready var max_enemy_health: int

@onready var player_active_deck = []
@onready var player_deck = []
@onready var player_skills = []
@onready var player_inventory_db = []
@onready var player_deck_db
@onready var player_active_inventory = []
@onready var player_inventory = []
@onready var player_talent_array = []
@onready var player_class = ""

@onready var current_merchant = "res://Scenes/Merchants/grack.tscn"
@onready var current_enemy = load("res://Resources/Enemies/Trogg.tres")
@onready var enemy_active_deck = []

var intermission_tracker = 0
var battle_tracker = 0
var current_scene = ""

var card_db_reference
var card_node_reference = 3

var mouse_occupied = false


func _ready():
	card_db_reference = preload("res://Resources/Cards/card_db.gd")
	max_player_health = 200
	player_health = max_player_health
	
	max_enemy_health = current_enemy.health
	enemy_health = max_enemy_health
	
	load_data()
	load_function()
	
	if player_inventory == null:
		instantiate_player_deck()
		instantiate_player_inventory()

func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)

func save():
	ResourceSaver.save(playerData, save_file_path + save_file_name)
	print("save")

func change_player_health(amount):
	player_health += amount
	if player_health > max_player_health:
		player_health = max_player_health

func change_enemy_health(amount):
	enemy_health += amount
	if enemy_health > max_enemy_health:
		enemy_health = max_enemy_health

func gain_xp(amount):
	player_xp += amount
	while player_xp >= xp_threshold:
		player_xp -= xp_threshold
		player_level += 1

func set_player_inventory():
	player_inventory_db = ["Strike", "Strike"]

func instantiate_player_inventory():
	for i in player_inventory_db:
		var card = load(card_db_reference.CARDS[i]).duplicate()
		card.is_players = true
		player_inventory.push_back(card)

func set_player_deck():
	player_deck_db = ["Strengthen", "Strike", "Strike", "Strike", "Strike", 
	"Strike", "Strike", "Strike", "Strike", "Strike"]

func instantiate_player_deck():
	for i in player_deck_db:
		var card = load(card_db_reference.CARDS[i]).duplicate()
		card.is_players = true
		player_deck.push_back(card)

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

	save()

func load_function():
	player_inventory = playerData.player_inventory
	player_deck = playerData.player_deck
	player_talent_array = playerData.player_talent_array
	player_class = playerData.player_class
	player_gold = playerData.player_gold
	player_xp = playerData.player_xp
	player_level = playerData.player_level
