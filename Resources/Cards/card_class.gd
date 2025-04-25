extends Node2D

class_name card

#UI=================================================================================================
var tooltip : PopupPanel
var tooltip_container : VBoxContainer
var upgrade_border : Sprite2D
var dmg_label : Label
var cd_panel : Panel
var cd_label : Label
var cd_overlay_label : Label
var cd_overlay_panel : Panel
var ui : Control
var card_shop_label: Label
var card_shop_panel : Panel
var alt_dmg_label : Label
var alt_dmg_panel : Panel
var modifiers : Node2D
var effects : Node2D

#AUDIO==============================================================================================
var audio : AudioStreamPlayer2D

#IMAGE==============================================================================================
var enchant_image : Sprite2D

#COLLISION==========================================================================================
var collision_shape : CollisionShape2D


var card_stats: Cards_Resource = null
var card_slotted = false
var is_discarded = false
var disabled_collision = false
var mouse_exit = false

func _ready():
	tooltip = get_node('%PopupPanel')
	tooltip_container = get_node('%TooltipContainer')
	upgrade_border = get_node('%UpgradeBorder')
	dmg_label = get_node('%DamageLabel')
	cd_panel = get_node('%CDPanel')
	cd_label = get_node('%CDLabel')
	cd_overlay_panel = get_node('%CDOverlayPanel')
	cd_overlay_label = get_node('%CDOverlayLabel')
	ui = get_node('%CardUI')
	card_shop_label= get_node('%ShopLabel')
	card_shop_panel = get_node('%ShopPanel')
	alt_dmg_label = get_node('%AltDamageLabel')
	alt_dmg_panel = get_node('%AltDamagePanel')
	modifiers = get_node('%Modifiers')
	effects = get_node('%Effects')
	audio = get_node('%AudioStreamPlayer2D')
	enchant_image = get_node('%ItemEnchantImage')
	collision_shape = get_node('%CollisionShape2D')

func effect(player_deck, enemy_deck, player, enemy):
	effects.effect(player_deck, enemy_deck, player, enemy)

func upgrade_card(num):
	effects.upgrade_card(num)

func item_enchant(enchant):
	effects.item_enchant(enchant)

func update_card_image():
	upgrade_border.texture = load(card_stats.card_upgrade_art_path)
	dmg_label.text = str(card_stats.dmg)
	if card_stats.cd > 0:
		cd_panel.visible = true
		cd_label.text = str(card_stats.cd)
	else: cd_panel.visible = false

func disable_collision():
	collision_shape.disabled = true
	ui.mouse_filter = Control.MOUSE_FILTER_IGNORE
	disabled_collision = true

func enable_collision():
	collision_shape.disabled = false
	ui.mouse_filter = Control.MOUSE_FILTER_STOP
	disabled_collision = false

func card_shop_ui():
	if card_stats.is_players:
		card_shop_label.text = str(card_stats.sell_price)

	if !card_stats.is_players:
		card_shop_label.text =  str(card_stats.buy_price)

func update_card_ui():
	update_card_image()
	change_item_enchant_image()
	toggle_cd()

func change_item_enchant_image():
	var enchant = card_stats.item_enchant
	match enchant:
		"Bleed":
			enchant_image.texture = load("res://Resources/Art/Enchantments/ItemEnhancement/bleed_enchant.png")
			update_tooltip("Bleed", "Deal " + str(card_stats.bleed_dmg) + " bleed damage",  "Bleed: ")
			update_damage_label("Bleed")
		"Exhaust":
			enchant_image.texture = load("res://Resources/Art/Enchantments/ItemEnhancement/exhaust_enchant.png")
			update_tooltip("Exhaust", "Put Opposing card on CD for 1 Round",  "Exhaust: ")
			update_damage_label("Exhaust")
		"Dejavu":
			enchant_image.texture = load("res://Resources/Art/Enchantments/ItemEnhancement/dejavu_enchant.png")
			update_tooltip("Dejavu", "Repeat Card Effects",  "Dejavu: ")
			update_damage_label("Dejavu")
		"Fiery":
			enchant_image.texture = load("res://Resources/Art/Enchantments/ItemEnhancement/fiery_enchant.png")
			update_tooltip("Burn", "Deal " + str(card_stats.burn_dmg) + " bleed damage",  "Burn: ")
			update_damage_label("Burn")
		"Lifesteal":
			enchant_image.texture = load("res://Resources/Art/Enchantments/ItemEnhancement/lifesteal_enchant.png")
			update_tooltip("Lifesteal", "Heal for " + str(card_stats.dmg) + " damage",  "Lifesteal: ")
			update_damage_label("Lifesteal")
		"Rapid":
			enchant_image.texture = load("res://Resources/Art/Enchantments/ItemEnhancement/rapid_enchant.png")
			update_tooltip("Rapid", "Reduce and random card's CD by 1",  "Rapid: ")
			update_damage_label("Rapid")
		"Restoration":
			enchant_image.texture = load("res://Resources/Art/Enchantments/ItemEnhancement/restoration_enchant.png")
			update_tooltip("Restoration", "Heal for " + str(card_stats.heal),  "Restoration: ")
			update_damage_label("Restoration")
		"Toxic":
			enchant_image.texture = load("res://Resources/Art/Enchantments/ItemEnhancement/toxic_enchant.png")
			update_tooltip("Poison", "Deal " + str(card_stats.poison_dmg) + " poison damage",  "Poison: ")
			update_damage_label("Poison")
		"Prosperity":
			enchant_image.texture = load("res://Resources/Art/Enchantments/ItemEnhancement/prosperity_enchant.png")
			update_tooltip("Prosperity", "Gain " + str(card_stats.prosperity) + " Gold",  "Prosperity: ")
			update_damage_label("Prosperity")
	
		_: enchant_image.texture = null


func _on_card_ui_mouse_entered():
	emit_signal("hovered_on", self)

func _on_card_ui_mouse_exited():
	emit_signal("hovered_off", self)

func toggle_tooltip_show():
	if tooltip_container.get_children() == []: return
	toggle_shop_ui(true)
	var mouse_pos = get_viewport().get_mouse_position()
	var correction = true
	
	#Toggles when mouse is on right side of screen
	if mouse_pos.x <= get_viewport_rect().size.x/2: correction = false
	
	if correction == false:
		tooltip.popup(Rect2i(position + Vector2(150, -180), Vector2i(0, 0))) 
	else:
		tooltip.popup(Rect2i(position, Vector2i(0, 0))) 
		tooltip.position = position + Vector2(-150 - tooltip.size.x , -180)

func toggle_tooltip_hide():
	toggle_shop_ui(false)
	tooltip.hide()

func update_tooltip(identifier, body = null, header = null,):
	var tooltip
	for i in tooltip_container.get_children():
		if i.name == identifier: 
			tooltip = i

	if tooltip == null:
		var hbox = HBoxContainer.new()
		hbox.name = identifier
		tooltip_container.add_child(hbox)
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
	var styleBox: StyleBoxFlat = alt_dmg_panel.get_theme_stylebox("panel").duplicate()
	if type == "Bleed":
		alt_dmg_panel.visible = true
		alt_dmg_label.text = str(card_stats.bleed_dmg)
		styleBox.set("bg_color", Color.FIREBRICK)
		alt_dmg_panel.add_theme_stylebox_override("panel", styleBox)
	if type == "Burn":
		alt_dmg_panel.visible = true
		alt_dmg_label.text = str(card_stats.burn_dmg)
		styleBox.set("bg_color", Color.CORAL)
		alt_dmg_panel.add_theme_stylebox_override("panel", styleBox)
	if type == "Poison":
		alt_dmg_panel.visible = true
		alt_dmg_label.text = str(card_stats.poison_dmg)
		styleBox.set("bg_color", Color.WEB_GREEN)
		alt_dmg_panel.add_theme_stylebox_override("panel", styleBox)
	if type == "Dejavu":
		alt_dmg_panel.visible = true
		alt_dmg_label.text = str("x2")
		styleBox.set("bg_color", Color.WHITE_SMOKE)
		alt_dmg_panel.add_theme_stylebox_override("panel", styleBox)
	if type == "Lifesteal":
		styleBox.set("bg_color", Color.MAROON)
		$CardUI/DmgNumContainer/DamagPanel.add_theme_stylebox_override("panel", styleBox)
	if type == "Restoration":
		alt_dmg_panel.visible = true
		alt_dmg_label.text = str(card_stats.heal)
		styleBox.set("bg_color", Color.GREEN_YELLOW)
		alt_dmg_panel.add_theme_stylebox_override("panel", styleBox)
	if type == "Prosperity":
		alt_dmg_panel.visible = true
		alt_dmg_label.text = str(card_stats.prosperity)
		styleBox.set("bg_color", Color.GOLDENROD)
		alt_dmg_panel.add_theme_stylebox_override("panel", styleBox)

func attack_animation(user):
	var tween = get_tree().create_tween()
	if user.is_in_group("enemy"):
		tween.tween_property(self, "position", position + Vector2(0, 64), .5 * Global.COMBAT_SPEED )
		tween.tween_property(self, "position", position + Vector2(0, 0), .5 * Global.COMBAT_SPEED )
	else:
		tween.tween_property(self, "position", position + Vector2(0, -64), .5 * Global.COMBAT_SPEED )
		await tween.finished
		audio.stream 
		audio.play()
		tween = get_tree().create_tween()
		tween.tween_property(self, "position", position + Vector2(0, 64), .5 * Global.COMBAT_SPEED )

func toggle_cd():
	if card_stats.on_cd: 
		cd_overlay_panel.visible = true
		cd_overlay_label.text = str(card_stats.cd_remaining)
	else: cd_overlay_panel.visible = false

func toggle_shop_ui(show):
	if show: card_shop_panel.visible = true
	if Global.current_scene == "shop" or  Global.current_scene == "AH" : return
	if !show:  card_shop_panel.visible = false

func card_reset():
	card_stats.cd_remaining = 0
	card_stats.on_cd = false
	card_stats.mode = ""
	update_card_ui()

func change_cd_remaining(amount):
	card_stats.cd_remaining += amount
	if card_stats.cd_remaining <= 0: 
		card_stats.cd_remaining = 0
		card_stats.on_cd = false
	update_card_ui()

func change_cd(amount):
	card_stats.cd += amount
	if card_stats.cd <= 0:
		card_stats.cd = 0
		card_stats.on_cd = false
	update_card_ui()

func add_modifier(modifier):
	modifiers.add_child(modifier)
	modifier.modifier_initializer(self)
	organzie_card_modifiers()

func organzie_card_modifiers():
	var counter = 0
	var x_offset = 0
	var y_offset = 0
	
	for i in modifiers.get_children():
		if counter >= 5: 
			x_offset = -32
			y_offset = 0
			counter = 0
		i.position = Vector2(x_offset + 62, y_offset + -80)
		y_offset += 30
		counter += 1

