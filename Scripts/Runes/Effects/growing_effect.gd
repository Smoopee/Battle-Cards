extends Node2D


func _ready():
	if get_tree().get_first_node_in_group("battle sim") != null:
		get_tree().get_first_node_in_group("battle sim").connect("start_of_battle", rune_effect1)
	
	if get_tree().get_first_node_in_group("enemy") != null:
		if get_tree().get_first_node_in_group("enemy").has_signal("generate_reward"):
			get_tree().get_first_node_in_group("enemy").connect("generate_reward", reward)

func rune_effect1():
	print("In rune of growing effect")
	var enemy = get_tree().get_first_node_in_group("enemy")
	enemy.change_attack(10)
	enemy.character_stats.max_health *= 1.5
	enemy.set_stat_container()

func reward():
	print("In growing reward")

func tooltip_effect():
	var parent = $".."
	var stats = parent.rune_stats
	parent.update_tooltip(str(stats.rune_name), 
	"Effect", 
	"Enemy cards are concealed \nReward will always be a skill", 
	"Effect:")
