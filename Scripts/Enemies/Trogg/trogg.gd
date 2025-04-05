extends Node2D

const BUFF_X_POSITION = 675
const BUFF_Y_POSITION = 170
const SKILL_X_POSITION = 600
const SKILL_Y_POSITION = 0

@export var enemy_stats_resource: Enemy_Resource

@onready var deck = $Deck.enemy_deck
@onready var enemy_skills = $Skills.enemy_skills

var character_stats: Enemy_Resource = null

var enemy_scene_path = "res://Scenes/Enemies/trogg.tscn"
var enemy_resource_path = "res://Resources/Enemies/Trogg.tres"

func _ready():
	set_stats(enemy_stats_resource)
	set_stat_container()
	set_skills()
	set_enemy_gold()
	set_enemy_xp()
	$EnemyUI/EnemyHealthBar.max_value = character_stats.health
	$EnemyUI/EnemyHealthBar.value = character_stats.health
	$EnemyUI/EnemyHealthBar/EnemyHealthLabel.text = str($EnemyUI/EnemyHealthBar.value) + "/" + str($EnemyUI/EnemyHealthBar.max_value)
	$EnemyUI/EnemySelectionHealth.text = str($EnemyUI/EnemyHealthBar.value) + "/" + str($EnemyUI/EnemyHealthBar.max_value)

func set_stats(stats = Enemy_Resource) -> void:
	character_stats = load("res://Resources/Enemies/Trogg.tres").duplicate()

func set_stat_container():
	$EnemyUI/StatContainer/AttackLabel.text = "Atk: " + str(character_stats.attack)
	$EnemyUI/StatContainer/DefenseLabel.text = "Def: " + str(character_stats.defense)
	$EnemyUI/StatContainer/ArmorLabel.text = "Armor: " +  str(character_stats.armor)

func set_skills():
	for i in $Skills.enemy_skills:
		var new_instance = i.instantiate()
		new_instance.attached_to = self
		$Skills.add_child(new_instance)
	
	organize_skills()

func set_enemy_gold():
	$EnemyUI/GoldAndXPBox/EnemyGold.text = str(character_stats.gold) + "g"

func set_enemy_xp():
	$EnemyUI/GoldAndXPBox/EnemyXP.text = str(character_stats.xp) + "xp"
	
#UI====================================================================================

func add_buff(buff, source):
	$BuffContainer.add_child(buff)
	print("Trogg add buff " + str(source))
	buff.buff_initializer(source, self)
	organize_buffs()

func organize_buffs():
	var x_offset = 0
	for i in $BuffContainer.get_children():
		i.position = $BuffContainer.position + Vector2(x_offset + BUFF_X_POSITION, BUFF_Y_POSITION)
		i.scale = Vector2(2,2)
		x_offset += 50

func organize_skills():
	var x_offset = 0
	for i in $Skills.get_children():
		i.position = Vector2(x_offset + SKILL_X_POSITION, SKILL_Y_POSITION)
		x_offset += 60

func change_enemy_health():
	$EnemyUI/EnemyHealthBar.value = Global.enemy_health
	$EnemyUI/EnemyHealthBar/EnemyHealthLabel.text = str($EnemyUI/EnemyHealthBar.value) + "/" + str($EnemyUI/EnemyHealthBar.max_value)

func change_attack(amount):
	character_stats.attack += amount
	$EnemyUI/StatContainer/AttackLabel.text = str(character_stats.attack) 
	
func change_defense(amount):
	character_stats.defense += amount
	$EnemyUI/StatContainer/DefenseLabel.text = str(character_stats.defense)

func change_armor(amount):
	character_stats.armor += amount
	$EnemyUI/StatContainer/ArmorLabel.text = str(character_stats.armor)




func get_reward():
	var rng = RandomNumberGenerator.new()
	var reward_array = $Deck.enemy_deck + $Skills.enemy_skills 
	reward_array.push_back("Doulbe Reward")
	var reward_index =  rng.randi_range(0, reward_array.size()-1)
	return reward_array[reward_index]


func active_deck_access():
	return Global.enemy_active_deck
