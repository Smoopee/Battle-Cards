extends Node2D

var one_shot = true
var skill_name = "Paper Shield"
var attached_to 

func _ready():
	$PopupPanel/VBoxContainer/Name.text = skill_name
	update_tooltip("Effect","Reduce the next 6+ damage to 0, once per battle",  "Effect: ")
	
	if Global.current_scene == "battle_sim":
		get_tree().get_first_node_in_group("battle sim").connect("physical_damage", skill_effect)

func skill_effect(card, source, value):
	print("In skil effect for paper shield")
	if one_shot == false: return
	if source == attached_to: return
	if value >= 6:
		get_tree().get_first_node_in_group("battle sim").damage = 0
		one_shot = false
		print("WE BLOCKED WITH A PAPER SHIELD")
		$Sprite2D.self_modulate.a = .5

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

func _on_panel_mouse_entered():
	toggle_tooltip_show()

func _on_panel_mouse_exited():
	toggle_tooltip_hide()
