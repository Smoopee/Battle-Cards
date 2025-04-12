extends Node2D

var rune_stats: Runes_Resource = null
var rune_name = "Concealed"


func _ready():
	$PopupPanel/VBoxContainer/Name.text = rune_name
	update_tooltip("Effect","WIP",  "Effect: ")
	

func rune_effect():
	pass

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

func rune_shop_ui():
	if rune_stats.rune_owner != get_tree().get_first_node_in_group("character"):
		$RuneUI/ShopPanel/ShopLabel.text =  str(rune_stats.buy_price)

func toggle_shop_ui(show):
	if show: $RuneUI/ShopPanel.visible = true
	if Global.current_scene == "shop": return
	if !show: $RuneUI/ShopPanel.visible = false




