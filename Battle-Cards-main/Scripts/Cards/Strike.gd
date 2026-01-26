extends Node2D

@onready var stats = card_stats
@onready var card = $BaseCard

var card_stats: Cards_Resource = null

func effect(player_deck, enemy_deck, player, enemy):
	var damage = stats.dmg
	damage = stats.owner.deal_physical_damage(damage)
	stats.target.take_physical_damage(damage)
	
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
			stats.dmg = 5
			stats.sell_price = 2
			stats.buy_price = 4
		2: 
			stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade2.png"
			stats.upgrade_level = 2
			stats.dmg = 10
			stats.sell_price = 4
			stats.buy_price = 8
		3:
			stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade3.png"
			stats.upgrade_level = 3
			stats.dmg = 20
			stats.sell_price = 8
			stats.buy_price = 16
		4:
			stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade4.png"
			stats.upgrade_level = 4
			stats.dmg = 40
			stats.sell_price = 16
			stats.buy_price = 32
	
	card.update_tooltip(str(stats.name), 
	"Effect", 
	"Deal " + str(stats.dmg) + " damage", 
	"Effect: ")
	card.upgrade_card_ui()

func item_enchant(enchant):
	match enchant:
		"Bleed":
			stats.item_enchant = "Bleed"
			stats.bleed_dmg = 8
			stats.sell_price *= 2
			stats.buy_price *= 2
			card.update_tooltip("Enchantment", "Bleed", "Deal " + str(stats.bleed_dmg) + " bleed damage",  "Bleed: ")
		"Exhaust":
			stats.item_enchant = "Exhaust"
			card.update_tooltip("Enchantment", "Exhaust", "Put Opposing card on CD for 1 Round",  "Exhaust: ")
		"Dejavu":
			stats.item_enchant = "Dejavu"
			card.update_tooltip("Enchantment", "Dejavu", "Repeat Card Effects",  "Dejavu: ")
		"Fiery":
			stats.item_enchant = "Fiery"
			stats.burn_dmg = 4
			stats.sell_price *= 2
			stats.buy_price *= 2
			card.update_tooltip("Enchantment", "Fiery", "Deal " + str(stats.burn_dmg) + " fire damage"  + "\n ",  "Fiery: ")
		"Lifesteal":
			stats.item_enchant = "Lifesteal"
			card.update_tooltip("Enchantment", "Lifesteal", "Heal for " + str(stats.dmg) + " damage",  "Lifesteal: ")
		"Rapid":
			stats.item_enchant = "Rapid"
			card.update_tooltip("Enchantment", "Rapid", "Reduce and random card's CD by 1",  "Rapid: ")
		"Restoration":
			stats.item_enchant = "Restoration"
			stats.heal = 10
			stats.sell_price *= 2
			stats.buy_price *= 2
			card.update_tooltip("Enchantment", "Restoration", "Heal for " + str(stats.heal),  "Restoration: ")
		"Toxic":
			stats.item_enchant = "Toxic"
			stats.poison_dmg = 2
			stats.sell_price *= 2
			stats.buy_price *= 2
			card.update_tooltip("Enchantment", "Poison", "Deal " + str(stats.poison_dmg) + " poison damage",  "Poison: ")
		"Prosperity":
			stats.item_enchant = "Prosperity"
			stats.prosperity += 5
			card.update_tooltip("Enchantment", "Prosperity", "Gain " + str(stats.prosperity) + " Gold",  "Prosperity: ")
	card.update_card_ui()

func update_card_ui():
	card.update_card_ui()
