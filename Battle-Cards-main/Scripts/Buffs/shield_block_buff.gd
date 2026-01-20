extends Node2D

var count = 0
var buff_name = "Shield Block"



func _ready():
	$PopupPanel/VBoxContainer/Name.text = buff_name

func buff_counter(amount = null):
	if amount == null: return
	count += amount
	$BuffCounters.text = str(count)

func buff_decrement(amount = null):
	count -= 1
	$BuffCounters.text = str(count)
	if count <= 0: queue_free()

func toggle_tooltip_show():
	if $PopupPanel/VBoxContainer.get_children() == []: return
	var mouse_pos = get_viewport().get_mouse_position()
	var correction 
	
	if mouse_pos.x <= get_viewport_rect().size.x/2:
		correction = Vector2(0, 0)
	else:
		#Toggles when mouse is on right side of screen
		correction = -Vector2($PopupPanel/VBoxContainer.size.x + 310, 0)
	$PopupPanel.popup(Rect2i(global_position + Vector2(20, -70) + correction, Vector2(0, 0)))

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

func _on_panel_mouse_entered():
	toggle_tooltip_show()

func _on_panel_mouse_exited():
	toggle_tooltip_hide()
