extends Node2D

class_name Consumable

var consumable_stats: Consumables_Resource = null
var shop_label: Label
var shop_panel: Panel
var info_label: Label
var effect: Node2D
var image: Sprite2D

func _ready():
	set_node_names()

func consumable_effect(target):
	effect.effect(target)

func consumable_shop_ui():
	if consumable_stats.consumable_owner != get_tree().get_first_node_in_group("character"):
		shop_label.text =  str(consumable_stats.buy_price)

func toggle_shop_ui(show):
	if show: shop_panel.visible = true
	if Global.current_scene == "shop": return
	if !show: shop_panel.visible = false

func toggle_info_ui(show):
	if show: info_label.visible = true
	if !show: info_label.visible = false
	if consumable_stats.stack_amount <= 1:  info_label.visible = false

func update_stack_ui():
	set_node_names()
	info_label.text = str(consumable_stats.stack_amount)

func set_node_names():
	shop_label = get_node('%ShopLabel')
	shop_panel = get_node('%ShopPanel')
	info_label = get_node('%InfoLabel')
	effect = get_node('%Effect')
	image = get_node('%ConsumableImage')
	
	image.texture = load(consumable_stats.consumable_art_path)
	z_index = 1
