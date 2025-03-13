extends Node

var save_file_path = "user://SaveData/"
var save_file_name = "PlayerSave.tres"
var playerData = PlayerData.new()

@onready var player_health: int
@onready var max_player_health: int

@onready var enemy_health: int
@onready var max_enemy_health: int

@onready var player_active_deck = []
@onready var player_deck = []
@onready var player_skills = []
@onready var player_inventory_db = []
@onready var player_deck_db
@onready var player_active_inventory = []
@onready var player_inventory = []
@onready var all_player_cards = []

@onready var current_merchant = "res://Scenes/Merchants/grack.tscn"
@onready var current_enemy = load("res://Resources/Enemies/Trogg.tres")
@onready var enemy_active_deck = []


var intermission_tracker = 0

var player_gold: int = 5
var player_xp: int = 0

var card_db_reference
var card_node_reference = 3

func _ready():
	card_db_reference = preload("res://Resources/Cards/card_db.gd")
	max_player_health = 200
	player_health = max_player_health
	
	max_enemy_health = 100
	enemy_health = max_enemy_health
	
	load_data()
	player_inventory = playerData.player_inventory
	player_deck = playerData.player_deck
	if player_inventory == null:
		instantiate_player_deck()
		instantiate_player_inventory()
	

func change_player_health(amount):
	player_health += amount
	if player_health > max_player_health:
		player_health = max_player_health

func change_enemy_health(amount):
	enemy_health += amount
	if enemy_health > max_enemy_health:
		enemy_health = max_enemy_health

func set_player_inventory():
	player_inventory_db = ["Rock", "Rock"]

func instantiate_player_inventory():
	for i in player_inventory_db:
		var card = load(card_db_reference.CARDS[i]).duplicate()
		player_inventory.push_back(card)


func set_player_deck():
	player_deck_db = ["Rock", "Rock", "Rock", "Rock", "Rock", 
	"Rock", "Rock", "Rock", "Rock", "Rock"]

func instantiate_player_deck():
	for i in player_deck_db:
		var card = load(card_db_reference.CARDS[i]).duplicate()
		player_deck.push_back(card)

func load_data():
	playerData = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)
	print("loaded")
	
