extends Node2D

signal hovered_on
signal hovered_off

var card_stats: Cards_Resource = null
var card_slotted = false
var is_discarded = false
var disabled_collision = false
var mouse_exit = false

func _ready():
	get_tree().get_nodes_in_group("card manager")[0].connect_card_signals(self)
	
	if card_stats != null:
		$PopupPanel/VBoxContainer/Name.text = str(card_stats.name)
		update_tooltip("Effect", "Deal " + str(card_stats.dmg) + " damage",  "Effect: ")

func set_stats(stats = Cards_Resource) -> void:
	card_stats = load("res://Resources/Cards/shift_stance.tres").duplicate()

func on_start(board):
	pass

func effect(player_deck, enemy_deck, player, enemy):
	var mode = card_stats.card_mode
	match mode:
		"Defensive Stance":
			print("Entered Battle Stance")
			card_stats.card_mode = "Battle Stance"
			player.player_stats.attack += card_stats.upgrade_effect1
			player.change_attack_label()
			player.player_stats.defense -= card_stats.upgrade_effect2
			player.change_defense_label()
			
		"Battle Stance":
			print("Enetered Defensive Stance")
			card_stats.card_mode = "Defensive Stance"
			player.player_stats.defense += card_stats.upgrade_effect2
			player.change_defense_label()
			player.player_stats.attack -= card_stats.upgrade_effect1
			player.change_attack_label()
		_: 
			print("Entered Defensive Stance")
			card_stats.card_mode = "Defensive Stance"
			player.player_stats.defense += card_stats.upgrade_effect2
			player.change_defense_label()
			

func upgrade_card(num):
	match num:
		1:
			card_stats.card_art_path = "res://Resources/Cards/CardArt/upgrade1.png"
			card_stats.upgrade_level = 1
			card_stats.sell_price = 2
			card_stats.buy_price = 4
		2: 
			card_stats.card_art_path = "res://Resources/Cards/CardArt/upgrade2.png"
			card_stats.upgrade_level = 2
			card_stats.sell_price = 4
			card_stats.buy_price = 8
		3:
			card_stats.card_art_path = "res://Resources/Cards/CardArt/upgrade3.png"
			card_stats.upgrade_level = 3
			card_stats.sell_price = 8
			card_stats.buy_price = 16
		4:
			card_stats.card_art_path = "res://Resources/Cards/CardArt/upgrade4.png"
			card_stats.upgrade_level = 4
			card_stats.sell_price = 16
			card_stats.buy_price = 32
	
	update_tooltip("Effect", "Deal " + str(card_stats.dmg) + " damage")
	update_card_ui()

func item_enchant(enchant):
	match enchant:
		"Bleed":
			card_stats.item_enchant = "Bleed"
			card_stats.bleed_dmg = 8
			card_stats.sell_price *= 2
			card_stats.buy_price *= 2
	update_card_ui()

#ALL CARDS FUNCTIONS-------------------------------------------------------------------------------
func update_card_image():
	$UpgradeBorder.texture = load(card_stats.card_art_path)
	$CardUI/DmgNumContainer/DamagPanel/DamageLabel.text = str(card_stats.dmg)
	if card_stats.cd > 0:
		$CardUI/CDPanel.visible = true
		$CardUI/CDPanel/CDLabel.text = str(card_stats.cd)
	else: $CardUI/CDPanel.visible = false

func disable_collision():
	$Area2D/CollisionShape2D.disabled = true
	$CardUI.mouse_filter = Control.MOUSE_FILTER_IGNORE
	disabled_collision = true

func enable_collision():
	$Area2D/CollisionShape2D.disabled = false
	$CardUI.mouse_filter = Control.MOUSE_FILTER_STOP
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
	toggle_cd()
	card_shop_ui()

func change_item_enchant_image():
	var enchant = card_stats.item_enchant
	
	if enchant == "Bleed":
		$ItemEnchantImage.texture = load("res://Resources/UI/ItemEnhancement/bleed_enhancement.png")
		update_tooltip("Bleed", "Deal " + str(card_stats.bleed_dmg) + " bleed damage",  "Bleed: ")
		update_damage_label("Bleed")
	
	else: $ItemEnchantImage.texture = null

func change_card_dmg_text():
	$CardUI/CardDamage.text = str(card_stats.dmg)

func _on_card_ui_mouse_entered():
	emit_signal("hovered_on", self)

func _on_card_ui_mouse_exited():
	emit_signal("hovered_off", self)

func toggle_tooltip_show():
	if $PopupPanel/VBoxContainer.get_children() == []: return
	toggle_shop_ui(true)
	var mouse_pos = get_viewport().get_mouse_position()
	var correction = true
	
	#Toggles when mouse is on right side of screen
	if mouse_pos.x <= get_viewport_rect().size.x/2: correction = false
	
	if correction == false:
		$PopupPanel.popup(Rect2i(position + Vector2(150, -180), Vector2i(0, 0))) 
	else:
		$PopupPanel.popup(Rect2i(position, Vector2i(0, 0))) 
		$PopupPanel.position = position + Vector2(-150 - $PopupPanel.size.x , -180)

func toggle_tooltip_hide():
	toggle_shop_ui(false)
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

func update_damage_label(type):
	var styleBox: StyleBoxFlat = $CardUI/DmgNumContainer/DamagPanel2.get_theme_stylebox("panel").duplicate()
	if type == "Bleed":
		$CardUI/DmgNumContainer/DamagPanel2.visible = true
		$CardUI/DmgNumContainer/DamagPanel2/DamageLabel.text = str(card_stats.bleed_dmg)
		styleBox.set("bg_color", Color.FIREBRICK)
		$CardUI/DmgNumContainer/DamagPanel2.add_theme_stylebox_override("panel", styleBox)

func attack_animation(user):
	var tween = get_tree().create_tween()
	if user.is_in_group("enemy"):
		tween.tween_property($".", "position", position + Vector2(0, 64), .5 * Global.COMBAT_SPEED )
		tween.tween_property($".", "position", position + Vector2(0, 0), .5 * Global.COMBAT_SPEED )
	else:
		tween.tween_property($".", "position", position + Vector2(0, -64), .5 * Global.COMBAT_SPEED )
		await tween.finished
		$AudioStreamPlayer2D.stream 
		$AudioStreamPlayer2D.play()
		tween = get_tree().create_tween()
		tween.tween_property($".", "position", position + Vector2(0, 64), .5 * Global.COMBAT_SPEED )

func toggle_cd():
	if card_stats.on_cd: 
		$CardUI/CDDisplayPanel.visible = true
		$CardUI/CDDisplayPanel/Label.text = str(card_stats.cd_remaining)
	else: $CardUI/CDDisplayPanel.visible = false

func toggle_shop_ui(show):
	if show: $CardUI/ShopPanel.visible = true
	if Global.current_scene == "shop": return
	if !show:  $CardUI/ShopPanel.visible = false
