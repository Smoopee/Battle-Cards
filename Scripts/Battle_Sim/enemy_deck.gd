extends Node2D

var enemy_deck = []


func _ready():
	pass

func build_deck():
	var enemy = load(Global.current_enemy).instantiate()
	get_parent().add_child(enemy)
	enemy_deck = enemy.enemy_deck
	
	for i in enemy_deck:
		var new_resource = i
		var new_instance = load(new_resource.card_scene_path).instantiate()
		add_child(new_instance)
	
	enemy.position = $"../UI/enemy_health".position 
