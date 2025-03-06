extends Control

@onready var player_damage_number = $player_damage_number
@onready var enemy_damage_number = $enemy_damage_number


func change_player_damage_number(value):
	print("THE VALUE OF DAMAGE IS " + str(value))
	player_damage_number.text = str(value) + " damage"

func change_enemy_damage_number(value):
	enemy_damage_number.text = str(value) + " damage"
