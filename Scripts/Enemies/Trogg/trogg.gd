extends Node2D

@export var enemy_stats_resource: Enemy_Resource

@onready var enemy_deck = $Deck.enemy_deck
@onready var enemy_skills = $Skills.enemy_skills

var enemy_stats: Enemy_Resource = null

var enemy_scene_path = "res://Scenes/Enemies/trogg.tscn"
var enemy_resource_path = "res://Resources/Enemies/Trogg.tres"

func _ready():
	set_stats(enemy_stats_resource)
	set_enemy_gold()
	set_enemy_xp()
	$EnemyUI/EnemyHealthBar/EnemyHealthLabel.text = str($EnemyUI/EnemyHealthBar.value) + "/" + str($EnemyUI/EnemyHealthBar.max_value)
	$EnemyUI/EnemySelectionHealth.text = str($EnemyUI/EnemyHealthBar.value) + "/" + str($EnemyUI/EnemyHealthBar.max_value)

func set_stats(stats = Enemy_Resource) -> void:
	enemy_stats = load("res://Resources/Enemies/Trogg.tres").duplicate()

func set_enemy_gold():
	$EnemyUI/GoldAndXPBox/EnemyGold.text = str(enemy_stats.gold) + "g"

func set_enemy_xp():
	$EnemyUI/GoldAndXPBox/EnemyXP.text = str(enemy_stats.xp) + "xp"

func get_reward():
	var rng = RandomNumberGenerator.new()
	var reward_array = $Deck.enemy_deck + $Skills.enemy_skills 
	reward_array.push_back("Doulbe Reward")
	var reward_index =  rng.randi_range(0, reward_array.size()-1)
	return reward_array[reward_index]

func add_debuff(debuff, amount):
	$DebuffContainer.add_child(debuff)
	debuff.debuff_counter(amount)

func increase_debuff(debuff, amount):
	debuff.debuff_counter(amount)

func change_enemy_health():
	$EnemyUI/EnemyHealthBar.value = Global.enemy_health
	$EnemyUI/EnemyHealthBar/EnemyHealthLabel.text = str($EnemyUI/EnemyHealthBar.value) + "/" + str($EnemyUI/EnemyHealthBar.max_value)
