extends Node2D

@export var character_stats_resource: Character_Resource

var player_stats: Character_Resource = null
var fueled_by_rage = false
var savagery = false
var indomitable = false
var vicious_swings = false
var blood_bath = false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_stats(character_stats_resource)
	set_talents()
	$RageBar.position = get_parent().position + Vector2(47, -64)
	$StatContainer/AttackLabel.text = "Atk: " + str(player_stats.attack)
	$StatContainer/ArmorLabel.text = "Armor: " +  str(player_stats.armor)

func set_stats(stats = Character_Resource) -> void:
	player_stats = load("res://Resources/Character/berserker.tres").duplicate()

func set_talents():
	for i in Global.player_talent_array:
		if i == null: continue
		var new_talent = load(i).instantiate()
		$Talents.add_child(new_talent)
		new_talent.set_talent()

func change_rage(source, value):
	var rage_bar = $RageBar
	if savagery: value = $Talents.get_node("Savagery").talent_effect(source, value)
	if indomitable: value = $Talents.get_node("Indomitable").talent_effect(source, value)
	rage_bar.value += value
	if  rage_bar.value  >= 100:
		if fueled_by_rage: player_stats.attack += 5
		else: player_stats.attack += 3
		change_attack_label()
		rage_bar.value = 0
		rage_bar.max_value += 10

func change_attack_label():
	$AttackLabel.text = str(player_stats.attack) + str("Atk")

func change_damage(card):
	pass

func change_deck(deck):
	if vicious_swings:
		for i in deck:
			i.card_stats.bleed_dmg += 2

func blood_bath_func(bleed_damage):
	print("In berserk blood bath")
	if blood_bath: 
		print(bleed_damage)
		return $"../..".change_health(false, -(bleed_damage /2))
