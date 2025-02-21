extends Control

@onready var player_health_bar = $player_health
@onready var enemy_health_bar = $enemy_health
@onready var player_card = $player_card
@onready var enemy_card = $enemy_card
@onready var player_damage_number = $player_damage_number
@onready var enemy_damage_number = $enemy_damage_number

func _ready():
	player_health_bar.max_value = Global.max_player_health
	player_health_bar.value = Global.player_health
	
	enemy_health_bar.max_value = Global.max_enemy_health
	enemy_health_bar.value = Global.enemy_health

func change_player_health(value):
	player_health_bar.value = value

func change_enemy_health(value):
	enemy_health_bar.value = value

func change_player_card(path):
	player_card.texture = load(path)

func change_enemy_card(path):
	enemy_card.texture = load(path)

func change_player_damage_number(value):
	print("THE VALUE OF DAMAGE IS " + str(value))
	player_damage_number.text = str(value) + " damage"

func change_enemy_damage_number(value):
	enemy_damage_number.text = str(value) + " damage"
