extends Node2D

@export var card_stats_resource: Cards_Resource

var card_stats: Cards_Resource = null
var card_slotted = false
var is_discarded = false
var disabled_collision = false


func set_stats(stats = Cards_Resource) -> void:
	card_stats = load("res://Resources/Cards/CardEnchants/bleed_enchant_card.tres").duplicate()

func upgrade_card(card):
	pass

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
		$CardUI/ShopPanel/ShopLabel.text = str(card_stats.sell_price)

	if !card_stats.is_players:
		$CardUI/ShopPanel/ShopLabel.text =  str(card_stats.buy_price)

func update_card_ui():
	update_card_image()
	change_item_enchant_image()
	change_card_dmg_text()

func change_item_enchant_image():
	pass

func change_card_dmg_text():
	pass

func toggle_shop_ui(show):
	if show: $CardUI/ShopPanel.visible = true
	if Global.current_scene == "shop": return
	if !show:  $CardUI/ShopPanel.visible = false
