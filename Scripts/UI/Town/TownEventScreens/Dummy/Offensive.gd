extends Node2D

func effect():
	var enemy = load("res://Scenes/Enemies/training_dummy.tscn").instantiate()
	add_child(enemy)
	enemy_loader(enemy)
	
	return "Offensive"

func enemy_loader(enemy):
	Global.current_enemy = enemy.character_stats
	Global.max_enemy_health = Global.current_enemy.health
	Global.enemy_health = Global.max_enemy_health
