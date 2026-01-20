extends Node2D

@onready var card_slots = $"../Enemy_Cards"
var enemy_deck

func _ready():
	var enemy = load(Global.current_enemy.enemy_scene_path).instantiate()
	add_child(enemy)
	enemy.character_stats = Global.current_enemy
	enemy.setup()
	enemy_deck = enemy.deck
	
	var center_screen_x = get_viewport().size.x / 2
	enemy.position = Vector2(center_screen_x, 180)



