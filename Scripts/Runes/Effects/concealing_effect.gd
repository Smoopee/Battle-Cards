extends Node2D


func _ready():
	if get_tree().get_first_node_in_group("enemy deck") != null:
		get_tree().get_first_node_in_group("enemy deck").connect("build_enemy_deck", rune_effect1)

	if get_tree().get_first_node_in_group("battle sim") != null:
		get_tree().get_first_node_in_group("battle sim").connect("start_of_round", rune_effect2)
		
	if get_tree().get_first_node_in_group("enemy") != null:
		if get_tree().get_first_node_in_group("enemy").has_signal("generate_reward"):
			get_tree().get_first_node_in_group("enemy").connect("generate_reward", reward)

func rune_effect1():
	var conceal_card = load("res://Resources/Cards/CardArt/concealed_card.png")
	for i in get_tree().get_first_node_in_group("enemy deck").get_children():
		if i.is_in_group("card"):
			i.get_node("CardImage").texture = conceal_card
			i.get_node("ItemEnchantImage").visible = false
			i.get_node("UpgradeBorder").visible = false
			i.get_node("CardUI").visible = false

func rune_effect2():
	print("concealing rune effect 2")
	for i in get_tree().get_first_node_in_group("enemy deck").get_children():
		if i.is_in_group("card"):
			i.get_node("CardImage").texture = load(i.card_stats.card_art_path)
			i.upgrade_card(i.card_stats.upgrade_level)
			i.item_enchant(i.card_stats.item_enchant)
			i.get_node("ItemEnchantImage").visible = true
			i.get_node("UpgradeBorder").visible = true
			i.get_node("CardUI").visible = true

func reward():
	#Global.current_enemy.gold += 1000
	
	#for i in get_tree().get_first_node_in_group("enemy").reward_array:
		#if i.get_script() == load("res://Resources/Cards/cards_master_resource.gd"):
			#i.item_enchant = "Bleed"
	
	#for i in get_tree().get_first_node_in_group("enemy").reward_array:
		#get_tree().get_first_node_in_group("enemy").reward_array = [load("res://Resources/Cards/strike.tres")]
	
	for i in get_tree().get_first_node_in_group("enemy").reward_array:
		get_tree().get_first_node_in_group("enemy").reward_array = [load("res://Resources/Skills/third_wheel.tres")]
	
	print("Here is your concealed reward")
