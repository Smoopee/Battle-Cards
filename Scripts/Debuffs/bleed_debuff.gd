extends Control

var count = 0
var debuff_name = "Bleed"

func _ready():
	$PopupPanel/VBoxContainer/Name.text = debuff_name
	update_tooltip("Effect", "Take " + str(count) + " damage this turn",  "Effect: ")

func debuff_counter(amount):
	count += amount
	$DebuffCounters.text = str(count)
	update_tooltip("Effect",  "Take " + str(count) + " damage this turn")

func debuff_decrement(amount = 1):
	count -= 1
	$DebuffCounters.text = str(count)
	update_tooltip("Effect",  "Take " + str(count) + " damage this turn")
	if count <= 0: queue_free()

func toggle_tooltip_show():
	if $PopupPanel/VBoxContainer.get_children() == []: return
	var mouse_pos = get_viewport().get_mouse_position()
	var correction = -Vector2($PopupPanel/VBoxContainer.size.x + 100, 0)
	$PopupPanel.popup(Rect2i(global_position + Vector2(0, 30) + correction, Vector2(0, 0)))

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
