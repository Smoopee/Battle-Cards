extends Node2D

@export var card_stats_resource: Cards_Resource

var card_stats: Cards_Resource = null

var card_slotted = false
var is_discarded = false
var disabled_collision = false
var mouse_exit = false



func set_stats(stats = Cards_Resource) -> void:
	card_stats = load("res://Resources/Cards/rock.tres").duplicate()
	

func on_start(board):
	pass

func effect(player_deck, enemy_deck, player, enemy):
	pass

func upgrade_card(num):
	match num:
		1:
			card_stats.card_art_path = "res://Resources/Cards/CardArt/Rock_card.png"
			card_stats.upgrade_level = 1
			card_stats.dmg = 2
			card_stats.sell_price = 1
			card_stats.buy_price = 2
		2: 
			card_stats.card_art_path = "res://Resources/Cards/CardArt/rock2_card.png"
			card_stats.upgrade_level = 2
			card_stats.dmg = 4
			card_stats.sell_price = 2
			card_stats.buy_price = 4
		3:
			card_stats.card_art_path = "res://Resources/Cards/CardArt/rock3_card.png"
			card_stats.upgrade_level = 3
			card_stats.dmg = 8 
			card_stats.sell_price = 4
			card_stats.buy_price = 8
		4:
			card_stats.card_art_path = "res://Resources/Cards/CardArt/rock4_card.png"
			card_stats.upgrade_level = 4
			card_stats.dmg = 16
			card_stats.sell_price = 8
			card_stats.buy_price = 16
	
	update_card_ui()
	

func item_enchant(enchant):
	match enchant:
		"Bleed":
			card_stats.item_enchant = "Bleed"
			card_stats.bleed_dmg = 6
			card_stats.sell_price *= 2
			card_stats.buy_price *= 2


	update_card_ui()
	
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


func _on_card_ui_mouse_entered():
	mouse_exit = false
	await get_tree().create_timer(1).timeout
	if mouse_exit == false: 
		Popups.card_popup(Rect2i(Vector2i(global_position), Vector2i(98, 128)), card_stats)

func _on_card_ui_mouse_exited():
	mouse_exit = true
	Popups.hide_card_popup()
