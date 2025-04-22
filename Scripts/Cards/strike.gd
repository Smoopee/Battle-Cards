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

func on_start(board):
	pass

func effect(player_deck, enemy_deck, player, enemy):
	var damage = card_stats.dmg
	damage = card_stats.owner.deal_physical_damage(damage)
	card_stats.target.take_physical_damage(damage)
	
	if card_stats.bleed_dmg > 0:
		card_stats.target.apply_bleeding_damage(card_stats.bleed_dmg)
	
	if card_stats.burn_dmg > 0:
		card_stats.target.apply_burning_damage(card_stats.burn_dmg)
	
	if card_stats.poison_dmg > 0:
		card_stats.target.apply_poisoning_damage(card_stats.poison_dmg)
	
	if card_stats.heal > 0:
		card_stats.owner.heal(card_stats.heal)
	
	if card_stats.prosperity > 0:
		Global.player_gold += card_stats.prosperity
		get_tree().get_first_node_in_group("bottom ui").change_player_gold()
	
	if card_stats.item_enchant == "Dejavu" and !card_stats.dejavu_used:
		card_stats.dejavu_used = true
		effect(player_deck, enemy_deck, player, enemy)
	
	if card_stats.item_enchant == "Lifesteal":
		card_stats.owner.lifesteal(damage)
	
	if card_stats.item_enchant == "Exhaust":
		var target = get_tree().get_first_node_in_group("battle sim").enemy_card
		if card_stats.owner == enemy: target = get_tree().get_first_node_in_group("battle sim").player_card
		target.add_modifier(load("res://Scenes/Modifiers/exhaust_modifier.tscn").instantiate())
	
	if card_stats.item_enchant == "Rapid":
		var temp_array = []
		for i in card_stats.owner.active_deck_access():
			if i == null: continue
			if i.cd_remaining > 1:
				temp_array.push_back(i)
		
		temp_array.shuffle()
		if temp_array.size() == 0: return
		temp_array[0].cd_remaining -= 1

		
func upgrade_card(num):
	match num:
		1:
			card_stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade1.png"
			card_stats.upgrade_level = 1
			card_stats.dmg = 5
			card_stats.sell_price = 2
			card_stats.buy_price = 4
		2: 
			card_stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade2.png"
			card_stats.upgrade_level = 2
			card_stats.dmg = 10
			card_stats.sell_price = 4
			card_stats.buy_price = 8
		3:
			card_stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade3.png"
			card_stats.upgrade_level = 3
			card_stats.dmg = 20
			card_stats.sell_price = 8
			card_stats.buy_price = 16
		4:
			card_stats.card_upgrade_art_path = "res://Resources/Cards/CardArt/upgrade4.png"
			card_stats.upgrade_level = 4
			card_stats.dmg = 40
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
		"Exhaust":
			card_stats.item_enchant = "Exhaust"
		"Dejavu":
			card_stats.item_enchant = "Dejavu"
		"Fiery":
			card_stats.item_enchant = "Fiery"
			card_stats.burn_dmg = 4
			card_stats.sell_price *= 2
			card_stats.buy_price *= 2
		"Lifesteal":
			card_stats.item_enchant = "Lifesteal"
		"Rapid":
			card_stats.item_enchant = "Rapid"
		"Restoration":
			card_stats.item_enchant = "Restoration"
			card_stats.heal = 10
			card_stats.sell_price *= 2
			card_stats.buy_price *= 2
		"Toxic":
			card_stats.item_enchant = "Toxic"
			card_stats.poison_dmg = 2
			card_stats.sell_price *= 2
			card_stats.buy_price *= 2
		"Prosperity":
			card_stats.item_enchant = "Prosperity"
			card_stats.prosperity += 5
	update_card_ui()

#ALL CARDS FUNCTIONS-------------------------------------------------------------------------------
func update_card_image():
	$UpgradeBorder.texture = load(card_stats.card_upgrade_art_path)
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
	match enchant:
		"Bleed":
			$ItemEnchantImage.texture = load("res://Resources/Art/Enchantments/ItemEnhancement/bleed_enchant.png")
			update_tooltip("Bleed", "Deal " + str(card_stats.bleed_dmg) + " bleed damage",  "Bleed: ")
			update_damage_label("Bleed")
		"Exhaust":
			$ItemEnchantImage.texture = load("res://Resources/Art/Enchantments/ItemEnhancement/exhaust_enchant.png")
			update_tooltip("Exhaust", "Put Opposing card on CD for 1 Round",  "Exhaust: ")
			update_damage_label("Exhaust")
		"Dejavu":
			$ItemEnchantImage.texture = load("res://Resources/Art/Enchantments/ItemEnhancement/dejavu_enchant.png")
			update_tooltip("Dejavu", "Repeat Card Effects",  "Dejavu: ")
			update_damage_label("Dejavu")
		"Fiery":
			$ItemEnchantImage.texture = load("res://Resources/Art/Enchantments/ItemEnhancement/fiery_enchant.png")
			update_tooltip("Burn", "Deal " + str(card_stats.burn_dmg) + " bleed damage",  "Burn: ")
			update_damage_label("Burn")
		"Lifesteal":
			$ItemEnchantImage.texture = load("res://Resources/Art/Enchantments/ItemEnhancement/lifesteal_enchant.png")
			update_tooltip("Lifesteal", "Heal for " + str(card_stats.dmg) + " damage",  "Lifesteal: ")
			update_damage_label("Lifesteal")
		"Rapid":
			$ItemEnchantImage.texture = load("res://Resources/Art/Enchantments/ItemEnhancement/rapid_enchant.png")
			update_tooltip("Rapid", "Reduce and random card's CD by 1",  "Rapid: ")
			update_damage_label("Rapid")
		"Restoration":
			$ItemEnchantImage.texture = load("res://Resources/Art/Enchantments/ItemEnhancement/restoration_enchant.png")
			update_tooltip("Restoration", "Heal for " + str(card_stats.heal),  "Restoration: ")
			update_damage_label("Restoration")
		"Toxic":
			$ItemEnchantImage.texture = load("res://Resources/Art/Enchantments/ItemEnhancement/toxic_enchant.png")
			update_tooltip("Poison", "Deal " + str(card_stats.poison_dmg) + " poison damage",  "Poison: ")
			update_damage_label("Poison")
		"Prosperity":
			$ItemEnchantImage.texture = load("res://Resources/Art/Enchantments/ItemEnhancement/prosperity_enchant.png")
			update_tooltip("Prosperity", "Gain " + str(card_stats.prosperity) + " Gold",  "Prosperity: ")
			update_damage_label("Prosperity")
	
		_: $ItemEnchantImage.texture = null

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
	if type == "Burn":
		$CardUI/DmgNumContainer/DamagPanel2.visible = true
		$CardUI/DmgNumContainer/DamagPanel2/DamageLabel.text = str(card_stats.burn_dmg)
		styleBox.set("bg_color", Color.CORAL)
		$CardUI/DmgNumContainer/DamagPanel2.add_theme_stylebox_override("panel", styleBox)
	if type == "Poison":
		$CardUI/DmgNumContainer/DamagPanel2.visible = true
		$CardUI/DmgNumContainer/DamagPanel2/DamageLabel.text = str(card_stats.poison_dmg)
		styleBox.set("bg_color", Color.WEB_GREEN)
		$CardUI/DmgNumContainer/DamagPanel2.add_theme_stylebox_override("panel", styleBox)
	if type == "Dejavu":
		$CardUI/DmgNumContainer/DamagPanel2.visible = true
		$CardUI/DmgNumContainer/DamagPanel2/DamageLabel.text = str("x2")
		styleBox.set("bg_color", Color.WHITE_SMOKE)
		$CardUI/DmgNumContainer/DamagPanel2.add_theme_stylebox_override("panel", styleBox)
	if type == "Lifesteal":
		styleBox.set("bg_color", Color.MAROON)
		$CardUI/DmgNumContainer/DamagPanel.add_theme_stylebox_override("panel", styleBox)
	if type == "Restoration":
		$CardUI/DmgNumContainer/DamagPanel2.visible = true
		$CardUI/DmgNumContainer/DamagPanel2/DamageLabel.text = str(card_stats.heal)
		styleBox.set("bg_color", Color.GREEN_YELLOW)
		$CardUI/DmgNumContainer/DamagPanel2.add_theme_stylebox_override("panel", styleBox)
	if type == "Prosperity":
		$CardUI/DmgNumContainer/DamagPanel2.visible = true
		$CardUI/DmgNumContainer/DamagPanel2/DamageLabel.text = str(card_stats.prosperity)
		styleBox.set("bg_color", Color.GOLDENROD)
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
	if Global.current_scene == "shop" or  Global.current_scene == "AH" : return
	if !show:  $CardUI/ShopPanel.visible = false

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
	$Modifiers.add_child(modifier)
	modifier.modifier_initializer(self)
	organzie_card_modifiers()

func organzie_card_modifiers():
	var counter = 0
	var x_offset = 0
	var y_offset = 0
	
	for i in $Modifiers.get_children():
		if counter >= 5: 
			x_offset = -32
			y_offset = 0
			counter = 0
		i.position = Vector2(x_offset + 62, y_offset + -80)
		y_offset += 30
		counter += 1
