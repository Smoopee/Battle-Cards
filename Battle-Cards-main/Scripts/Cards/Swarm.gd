extends Node2D

@onready var stats = card_stats
@onready var card = $BaseCard

var card_stats: Cards_Resource = null

func effect(player_deck, enemy_deck, player, enemy):
	var damage = stats.dmg
	damage = stats.owner.deal_physical_damage(damage)
	stats.target.take_physical_damage(damage)
	
	var target_deck = enemy_deck
	if stats.owner == player: target_deck = player_deck
	
	for i in target_deck:
		if i.card_stats.name == "Swarm":
			i.get_node("BaseCard").add_modifier(load("res://Scenes/Modifiers/swarm_modifier.tscn").instantiate())
	
	#ENCHANTS EFFECTS===============================================================================
	
	if stats.bleed_dmg > 0:
		stats.target.apply_bleeding_damage(stats.bleed_dmg)
	
	if stats.burn_dmg > 0:
		stats.target.apply_burning_damage(stats.burn_dmg)
	
	if stats.poison_dmg > 0:
		stats.target.apply_poisoning_damage(stats.poison_dmg)
	
	if stats.heal > 0:
		stats.owner.heal(stats.heal)
	
	if stats.prosperity > 0:
		Global.player_gold += stats.prosperity
		get_tree().get_first_node_in_group("bottom ui").change_player_gold()
	
	if stats.item_enchant == "Dejavu" and !stats.dejavu_used:
		stats.dejavu_used = true
		effect(player_deck, enemy_deck, player, enemy)
	
	if stats.item_enchant == "Lifesteal":
		stats.owner.lifesteal(damage)
	
	if stats.item_enchant == "Exhaust":
		var target = get_tree().get_first_node_in_group("battle sim").enemy_card
		if stats.owner == enemy: target = get_tree().get_first_node_in_group("battle sim").player_card
		target.add_modifier(load("res://Scenes/Modifiers/exhaust_modifier.tscn").instantiate())
	
	if stats.item_enchant == "Rapid":
		var temp_array = []
		for i in stats.owner.active_deck_access():
			if i == null: continue
			if i.cd_remaining > 1:
				temp_array.push_back(i)
		
		temp_array.shuffle()
		if temp_array.size() == 0: return
		temp_array[0].cd_remaining -= 1

func upgrade_card(num):
	match num:
		1:
			stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade1.png"
			stats.upgrade_level = 1
			stats.dmg = 1
			stats.sell_price = 2
			stats.buy_price = 4
		2: 
			stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade2.png"
			stats.upgrade_level = 2
			stats.dmg = 2
			stats.sell_price = 4
			stats.buy_price = 8
		3:
			stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade3.png"
			stats.upgrade_level = 3
			stats.dmg = 3
			stats.sell_price = 8
			stats.buy_price = 16
		4:
			stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade4.png"
			stats.upgrade_level = 4
			stats.dmg = 4
			stats.sell_price = 16
			stats.buy_price = 32
	
	card.update_tooltip(str(stats.name), "Effect", "Deal " + str(stats.dmg) + " damage. 
	 \nIncrease the damage of Swarm cards by 1", "Effect: ")
	card.upgrade_card_ui()

func item_enchant(enchant):
	match enchant:
		"Bleed":
			stats.item_enchant = "Bleed"
			stats.bleed_dmg = 8
			stats.sell_price *= 2
			stats.buy_price *= 2
		"Exhaust":
			stats.item_enchant = "Exhaust"
		"Dejavu":
			stats.item_enchant = "Dejavu"
		"Fiery":
			stats.item_enchant = "Fiery"
			stats.burn_dmg = 4
			stats.sell_price *= 2
			stats.buy_price *= 2
		"Lifesteal":
			stats.item_enchant = "Lifesteal"
		"Rapid":
			stats.item_enchant = "Rapid"
		"Restoration":
			stats.item_enchant = "Restoration"
			stats.heal = 10
			stats.sell_price *= 2
			stats.buy_price *= 2
		"Toxic":
			stats.item_enchant = "Toxic"
			stats.poison_dmg = 2
			stats.sell_price *= 2
			stats.buy_price *= 2
		"Prosperity":
			stats.item_enchant = "Prosperity"
			stats.prosperity += 5
	card.update_card_ui()
