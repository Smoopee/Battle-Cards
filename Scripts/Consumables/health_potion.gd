extends Node2D

var consumable_stats: Consumables_Resource = null
var consumable_name = "Health Potion"
var target 
var usable = true

func _ready():
	$PopupPanel/VBoxContainer/Name.text = consumable_name
	update_tooltip("Effect","Reduce the next 6+ damage to 0, once per battle",  "Effect: ")

func consumable_effect():
	Global.change_player_health(50)
	get_tree().get_first_node_in_group("character").change_player_health()

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
