extends Node2D


@onready var stats = rune_stats
@onready var rune = $BaseRune

var rune_stats: Runes_Resource = null


func activate_rune():
	get_tree().get_first_node_in_group("battle sim").connect("end_of_round", rune_effect1)
	get_tree().get_first_node_in_group("enemy").connect("generate_reward", reward)
	
	tooltip_effect()

func rune_effect1(round):
	var enemy = get_tree().get_first_node_in_group("enemy")
	var buff_resource = load("res://Resources/Buffs/growing.tres")
	enemy.add_buff(buff_resource, rune)
	

func rune_effect2():
	for i in get_tree().get_first_node_in_group("enemy deck").get_children():
		if i.is_in_group("card"):
			i.get_node("BaseCard").get_node("CardImage").texture = load(i.card_stats.card_art_path)
			i.get_node("BaseCard").upgrade_card(i.card_stats.upgrade_level)
			i.get_node("BaseCard").item_enchant(i.card_stats.item_enchant)
			i.get_node("BaseCard").get_node("ItemEnchantImage").visible = true
			i.get_node("BaseCard").get_node("UpgradeBorder").visible = true
			i.get_node("BaseCard").get_node("CardUI").visible = true

func reward():
	for i in get_tree().get_first_node_in_group("enemy").reward_array:
		get_tree().get_first_node_in_group("enemy").reward_array = [load("res://Resources/Skills/third_wheel.tres")]
	

func tooltip_effect():
	rune.update_tooltip(str(stats.rune_name), 
	"Effect", 
	"Enemy cards are concealed \nReward will always be a skill", 
	"Effect:")
