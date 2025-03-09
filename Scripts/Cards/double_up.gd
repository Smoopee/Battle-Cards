extends Node2D


@export var card_stats_resource: Cards_Resource

var card_stats: Cards_Resource = null

var card_slotted = false
var is_discarded = false
var disabled_collision = false
var upgrade_effect


func set_stats(stats = Cards_Resource) -> void:
	card_stats = load("res://Resources/Cards/double_up.tres").duplicate()

func on_start(board):
	pass

func effect(player_deck, enemy_deck, player, enemy):
	var buff = preload("res://Scenes/Buffs/double_up_buff.tscn")
	var card_position = card_stats.deck_position
	var new_instance = buff.instantiate()
	new_instance.multiplier = upgrade_effect
	var switch = false
	
	var combat_log_selection
	var combat_log_bleed_return
	
	while switch == false:
		if card_stats.in_enemy_deck == true:
			if enemy_deck[card_position].is_in_group("weapon"):
				enemy_deck[card_position].add_child(new_instance)
				combat_log_selection = enemy_deck[card_position]
				switch = true
			else:
				card_position += 1
				if card_position >= enemy_deck.size(): return
		else:
			if player_deck[card_position].is_in_group("weapon"):
				player_deck[card_position].add_child(new_instance)
				combat_log_selection = player_deck[card_position]
				switch = true
			else:
				card_position += 1
				if card_position >= player_deck.size(): return
	
	if card_stats.item_enchant == "Bleed":
		if card_stats.in_enemy_deck == true:
			player.player_stats.bleeding_dmg *= 2
			combat_log_bleed_return = " and doubled your bleeding damage to " + str(player.player_stats.bleeding_dmg)
		else:
			enemy.enemy_stats.bleeding_dmg *= 2
			combat_log_bleed_return = " and doubled the enemy's bleeding damage to " + str(enemy.enemy_stats.bleeding_dmg)
			
	var combat_log_return = "Double Up multiplied " + str(combat_log_selection.card_stats.name) + " damage by " + str(upgrade_effect)
	if combat_log_bleed_return: combat_log_return += combat_log_bleed_return
	
	return combat_log_return

func upgrade_card(num):
	match num:
		1:
			print("level 1!")
			card_stats.card_art_path= "res://Resources/Cards/CardArt/double_up_card.png"
			card_stats.upgrade_level = 1
			card_stats.sell_price = 3
			card_stats.buy_price = 6
			upgrade_effect = 2
		2: 
			print("level 2!")
			card_stats.card_art_path = "res://Resources/Cards/CardArt/double_up2_card.png"
			card_stats.upgrade_level = 2
			card_stats.sell_price = 6
			card_stats.buy_price = 12
			upgrade_effect = 2.5
		3:
			print("level 3!")
			card_stats.card_art_path = "res://Resources/Cards/CardArt/double_up3_card.png"
			card_stats.upgrade_level = 3
			card_stats.sell_price = 12
			card_stats.buy_price = 24
			upgrade_effect = 3
		4:
			print("level 4!")
			card_stats.card_art_path = "res://Resources/Cards/CardArt/double_up4_card.png"
			card_stats.upgrade_level = 4
			card_stats.sell_price = 24
			card_stats.buy_price = 48
			upgrade_effect = 3.5


func item_enchant(enchant):
	match enchant:
		"Bleed":
			card_stats.item_enchant = "Bleed"
			card_stats.sell_price *= 2
			card_stats.buy_price *= 2

#ALL CARDS FUNCTIONS-------------------------------------------------------------------------------
func update_card_image():
	$CardImage.texture = load(card_stats.card_art_path)

func disable_collision():
	$Area2D/CollisionShape2D.disabled = true
	disabled_collision = true
func enable_collision():
	$Area2D/CollisionShape2D.disabled = false
	disabled_collision = false

func card_shop_ui():
	if card_stats.is_players:
		$CardUI/SellPrice.text = str(card_stats.sell_price) + "g"
		$CardUI/BuyPrice.text = ""
	
	if !card_stats.is_players:
		$CardUI/BuyPrice.text = "- " + str(card_stats.buy_price) + "g"
		$CardUI/SellPrice.text = ""

func update_card_ui():
	update_card_image()
	change_item_enchant_image()
	change_card_dmg_text()

func change_item_enchant_image():
	var enchant = card_stats.item_enchant
	
	if enchant == "Bleed":
		$CardUI/HBoxContainer/ItemEnchantImage.texture = load("res://Resources/UI/ItemEnhancement/bleed_enhancement.png")

func change_card_dmg_text():
	$CardUI/HBoxContainer/CardDamage.text = str(card_stats.dmg)
