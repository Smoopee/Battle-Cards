extends Node2D

var skill_stats: Skills_Resource = null
var skill_name = "Third Wheel"
var attached_to 
var counter = 0

func _ready():
	$PopupPanel/VBoxContainer/Name.text = skill_name
	update_tooltip("Effect","Every 3rd Attack get +5 Damage",  "Effect: ")
	
	if Global.current_scene == "battle_sim":
		get_tree().get_first_node_in_group("battle sim").connect("card_etb", skill_effect)

func skill_effect(card):
	$SkillUI/InfoLabel.visible = true
	if attached_to != card.card_stats.card_owner: return
	if card.card_stats.card_type.find("Attack") >= 0:
		if counter >= 3:
			get_tree().get_first_node_in_group("battle sim").damage += 5
			counter = 1
		else: counter += 1
	update_counter_text()

func upgrade_skill(num):
	match num:
		1:
			skill_stats.skill_art_path = "res://Resources/Art/Skills/skill_upgrade1.png"
			skill_stats.upgrade_level = 1
			skill_stats.buy_price = 2
		2: 
			skill_stats.skill_art_path = "res://Resources/Art/Skills/skill_upgrade2.png"
			skill_stats.upgrade_level = 2
			skill_stats.buy_price = 4
		3:
			skill_stats.skill_art_path = "res://Resources/Art/Skills/skill_upgrade3.png"
			skill_stats.upgrade_level = 3
			skill_stats.buy_price = 8
		4:
			skill_stats.skill_art_path = "res://Resources/Art/Skills/skill_upgrade4.png"
			skill_stats.upgrade_level = 4
			skill_stats.buy_price = 16
		
	update_skill_image()
	update_tooltip("Effect", "WIP" + " damage")

func update_skill_image():
	$UpgradeBorder.texture = load(skill_stats.skill_art_path)

func update_counter_text():
	$SkillUI/InfoLabel.text = str(counter)


# UI FUNCTIONS =====================================================================================
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

func skill_shop_ui():
	if skill_stats.skill_owner != get_tree().get_first_node_in_group("character"):
		$SkillUI/ShopPanel/ShopLabel.text =  str(skill_stats.buy_price)

func toggle_shop_ui(show):
	if show: $SkillUI/ShopPanel.visible = true
	if Global.current_scene == "shop": return
	if !show:  $SkillUI/ShopPanel.visible = false
