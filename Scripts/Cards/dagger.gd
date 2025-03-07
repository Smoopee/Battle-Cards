extends Node2D

@export var card_stats_resource: Cards_Resource

var card_stats: Cards_Resource = null
var card_slotted = false
var is_discarded = false
var disabled_collision = false

func set_stats(stats = Cards_Resource) -> void:
	card_stats = load("res://Resources/Cards/dagger.tres").duplicate()

func on_start(board):
	pass

func effect(player_deck, enemy_deck):
	pass

func upgrade_card(num):
	match num:
		1:
			card_stats.card_art_path = "res://Resources/Cards/CardArt/Dagger_card.png"
			card_stats.upgrade_level = 1
			card_stats.dmg = 3
			card_stats.sell_price = 2
			card_stats.buy_price = 4
		2: 
			card_stats.card_art_path = "res://Resources/Cards/CardArt/dagger2_card.png"
			card_stats.upgrade_level = 2
			card_stats.dmg = 6
			card_stats.sell_price = 4
			card_stats.buy_price = 8
		3:
			card_stats.card_art_path = "res://Resources/Cards/CardArt/dagger3_card.png"
			card_stats.upgrade_level = 3
			card_stats.dmg = 12
			card_stats.sell_price = 8
			card_stats.buy_price = 16
		4:
			card_stats.card_art_path = "res://Resources/Cards/CardArt/dagger3_card.png"
			card_stats.upgrade_level = 4
			card_stats.dmg = 24
			card_stats.sell_price = 16
			card_stats.buy_price = 32
			

func item_enchant(enchant):
	match enchant:
		"Bleed":
			get_parent().card_resource.item_enchant = "Bleed"
			get_parent().card_resource.bleed_dmg = 6
			get_parent().card_resource.sell_price *= 2
			get_parent().card_resource.buy_price *= 2
			print("Bleeding for " + str(get_parent().card_resource.bleed_dmg))


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
