extends Node2D

var consumable_stats: Consumables_Resource = null
var consumable_name = "Battery"
var target 
var usable = true

func _ready():
	$PopupPanel/VBoxContainer/Name.text = consumable_name
	update_tooltip("Effect","WIP",  "Effect: ")

func consumable_effect(card):
	print("In battery consumable")
	if Global.current_scene != "battle_sim": return false
	if card.card_stats.cd_remaining <= 0: return false
	card.change_cd_remaining(-2)
	return true

func toggle_tooltip_show():
	if $PopupPanel/VBoxContainer.get_children() == []: return
	$PopupPanel.popup(Rect2i(global_position + Vector2(20, -70), Vector2(0, 0)))

func toggle_tooltip_hide():
	$PopupPanel.hide()

func update_tooltip(identifier, body = null, header = null,):
	var tooltip
	for i in $PopupPanel/VBoxContainer.get_children():
		if i.name == identifier: 
			tooltip = i

	if tooltip == null:
		var hbox = HBoxContainer.new()
		hbox.name = identifier
		$PopupPanel/VBoxContainer.add_child(hbox)
		var name_label = Label.new()
		hbox.add_child(name_label)
		name_label.add_theme_color_override("font_color", Color.BLACK)
		name_label.text = str(header)
		var body_label = Label.new()
		hbox.add_child(body_label)
		body_label.add_theme_color_override("font_color", Color.BLACK)
		body_label.text = str(body)
	
	else:
		tooltip.get_child(1).text = str(body)

func consumable_shop_ui():
	if consumable_stats.consumable_owner != get_tree().get_first_node_in_group("character"):
		$ConsumableUI/ShopPanel/ShopLabel.text =  str(consumable_stats.buy_price)

func toggle_shop_ui(show):
	if show: $ConsumableUI/ShopPanel.visible = true
	if Global.current_scene == "shop": return
	if !show: $ConsumableUI/ShopPanel.visible = false
