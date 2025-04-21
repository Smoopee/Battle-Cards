extends Node2D

var skill_stats: Skills_Resource = null
var one_shot = true
var skill_name = "Paper Shield"
var attached_to 

func _ready():
	$PopupPanel/VBoxContainer/Name.text = skill_name
	update_tooltip("Effect","Reduce the next 6+ damage to 0, once per battle",  "Effect: ")
	
	if Global.current_scene == "battle_sim":
		get_tree().get_first_node_in_group("battle sim").connect("physical_damage", skill_effect)

func skill_effect(source, target, damage, card):
	print("In skills effect for paper shield")
	if one_shot == false: return
	if source == attached_to: return
	if damage >= 6:
		get_tree().get_first_node_in_group("battle sim").damage = 0
		one_shot = false
		print("WE BLOCKED WITH A PAPER SHIELD")
		$SkillImage.self_modulate.a = .5
		$UpgradeBorder.self_modulate.a = .5

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
	if skill_stats.owner != get_tree().get_first_node_in_group("character"):
		$SkillUI/ShopPanel/ShopLabel.text =  str(skill_stats.buy_price)

func toggle_shop_ui(show):
	if show: $SkillUI/ShopPanel.visible = true
	if Global.current_scene == "shop": return
	if !show:  $SkillUI/ShopPanel.visible = false
