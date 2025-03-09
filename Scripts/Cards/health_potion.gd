extends Node2D


@export var card_stats_resource: Cards_Resource

var card_stats: Cards_Resource = null

var card_slotted = false
var is_discarded = false
var disabled_collision = false


func set_stats(stats = Cards_Resource) -> void:
	card_stats = load("res://Resources/Cards/health_potion.tres").duplicate()

func on_start(board):
	pass

func effect(player_deck, enemy_deck, player, enemy):
	pass

func upgrade_card(num):
	match num:
		1:
			print("level 1!")
			card_stats.card_art_path = "res://Resources/Cards/CardArt/health_potion_card.png"
			card_stats.upgrade_level = 1
			card_stats.heal = 3
		2: 
			print("level 2!")
			card_stats.card_art_path = "res://Resources/Cards/CardArt/health_potion2_card.png"
			card_stats.upgrade_level = 2
			card_stats.heal = 6
		3:
			print("level 3!")
			card_stats.card_art_path = "res://Resources/Cards/CardArt/health_potion3_card.png"
			card_stats.upgrade_level = 3
			card_stats.heal = 12
		4:
			print("level 4!")
			card_stats.card_art_path = "res://Resources/Cards/CardArt/health_potion4_card.png"
			card_stats.upgrade_level = 4
			card_stats.heal = 24
			

func item_enchant(enchant):
	print(card_stats)
	match enchant:
		"Bleed":
			card_stats.item_enchant = "Bleed"
			card_stats.bleed_dmg = 6
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
