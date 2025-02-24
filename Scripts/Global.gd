extends Node

@onready var player_health: int
@onready var max_player_health: int

@onready var enemy_health: int
@onready var max_enemy_health: int

@onready var player_deck = []
@onready var current_enemy = ""
@onready var player_inventory = []

func _ready():
	max_player_health = 100
	player_health = max_player_health
	
	max_enemy_health = 100
	enemy_health = max_enemy_health

func change_player_health(amount):
	player_health += amount
	if player_health > max_player_health:
		player_health = max_player_health

func change_enemy_health(amount):
	enemy_health += amount
	if enemy_health > max_enemy_health:
		enemy_health = max_enemy_health
