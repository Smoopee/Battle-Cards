extends Node2D

@onready var merchant_stats = get_parent().merchant_stats
@onready var glow_effect = $GlowEffect

var glow_power = 3.0
var speed = 2.0
var tooltip : Panel
var tooltip_container : VBoxContainer
var tooltip_name : Label
var merchant_image : Sprite2D
var merchant_border : Sprite2D
var ui : Control
var collision_shape : CollisionShape2D

var disabled_collision = false
var db_reference
var inventory
var inventory_selection

func _ready():
	set_node_names()
	get_db_reference()
	get_parent().add_to_group("merchant")
	self.scale = Global.ui_scaler

func _process(delta):
	if glow_effect:
		glow_power += delta * speed
		if glow_power >= 2.0 and speed > 0 or glow_power <= 1.0 and speed < 0:
			speed *= -1.0
		$GlowEffect.modulate.a = glow_power/ 4
		$GlowEffect.get_material().set_shader_parameter("glow_power", glow_power)

func set_node_names():
	tooltip = get_node('%TooltipPanel')
	tooltip_container = tooltip.get_child(0)
	ui = get_node('%MerchantUI')
	collision_shape = get_node('%CollisionShape2D')
	merchant_image = get_node('%MerchantImage')
	merchant_border = get_node('%BorderImage')
	z_index = 1
	merchant_image.texture = load(merchant_stats.merchant_art_path)
	merchant_border.texture = load(merchant_stats.merchant_border_path)

func get_db_reference():
	match merchant_stats.merchant_type:
		"Card":
			db_reference = preload("res://Resources/Cards/card_db.gd")
		"Rune":
			db_reference = preload("res://Resources/Runes/rune_db.gd")
		"Skill":
			db_reference = preload("res://Resources/Skills/skill_db.gd")
		"Consumable":
			db_reference = preload("res://Resources/Consumables/consumable_db.gd")
		"Gadget":
			db_reference = preload("res://Resources/Gadgets/gadget_db.gd")
		"Enchantment":
			db_reference = preload("res://Resources/Enchantments/enchantment_db.gd")

func get_inventory():
	inventory = []
	inventory_selection = []
	
	if merchant_stats.merchant_type == "Card":
		get_card_selection()
		create_inventory()

	if merchant_stats.merchant_type == "Skill":
		get_skill_selection()
		create_inventory()
	
	if merchant_stats.merchant_type == "Gadget":
		get_gadget_selection()
		create_inventory()
	
	if merchant_stats.merchant_type == "Consumable":
		get_consumable_selection()
		create_inventory()
	
	if merchant_stats.merchant_type == "Rune":
		get_rune_selection()
		create_inventory()

func get_card_selection():
	if merchant_stats.selection_tags == []:
		for i in db_reference.ITEMS:
			var temp = load(db_reference.ITEMS[i])
			inventory_selection.push_back(temp)
	
	else:
		for i in merchant_stats.selection_tags:
			for j in db_reference.ITEMS:
				var temp = load(db_reference.ITEMS[j])
				if temp.tags.find(i) > -1 : 
					inventory_selection.push_back(temp)

func get_skill_selection():
	if merchant_stats.selection_tags == []:
		for i in db_reference.ITEMS:
			var temp = load(db_reference.ITEMS[i])
			inventory_selection.push_back(temp)
	
	else:
		for i in merchant_stats.selection_tags:
			for j in db_reference.ITEMS:
				var temp = load(db_reference.ITEMS[j])
				if temp.tags.find(i) > -1 : 
					inventory_selection.push_back(temp)

func get_gadget_selection():
	if merchant_stats.selection_tags == []:
		for i in db_reference.ITEMS:
			var temp = load(db_reference.ITEMS[i])
			inventory_selection.push_back(temp)
	
	else:
		for i in merchant_stats.selection_tags:
			for j in db_reference.ITEMS:
				var temp = load(db_reference.ITEMS[j])
				if temp.tags.find(i) > -1 : 
					inventory_selection.push_back(temp)

func get_consumable_selection():
	if merchant_stats.selection_tags == []:
		for i in db_reference.ITEMS:
			var temp = load(db_reference.ITEMS[i])
			inventory_selection.push_back(temp)
	
	else:
		for i in merchant_stats.selection_tags:
			for j in db_reference.ITEMS:
				var temp = load(db_reference.ITEMS[j])
				if temp.tags.find(i) > -1 : 
					inventory_selection.push_back(temp)

func get_rune_selection():
	if merchant_stats.selection_tags == []:
		for i in db_reference.ITEMS:
			var temp = load(db_reference.ITEMS[i])
			inventory_selection.push_back(temp)
	
	else:
		for i in merchant_stats.selection_tags:
			for j in db_reference.ITEMS:
				var temp = load(db_reference.ITEMS[j])
				if temp.tags.find(i) > -1 : 
					inventory_selection.push_back(temp)

func create_inventory():
	for i in range(0, merchant_stats.stock_quantity):
		var selection = random_item_selection().duplicate()
		inventory.push_front(selection)

func random_item_selection():
	var rng = RandomNumberGenerator.new()
	
	var item_selection_index = rng.randi_range(0, inventory_selection.size()-1)
	var selection = inventory_selection[item_selection_index]
	if merchant_stats.merchant_type == "Skill": inventory_selection.remove_at(item_selection_index)
	if merchant_stats.merchant_type == "Gadget": inventory_selection.remove_at(item_selection_index)
	return selection

func highlight_card(being_dragged):
	if being_dragged:
		z_index = 2
		$GlowEffect.visible = false
	else:
		z_index = 1
		$GlowEffect.visible = true

func disable_collision():
	collision_shape.disabled = true
	ui.mouse_filter = Control.MOUSE_FILTER_IGNORE
	disabled_collision = true

func enable_collision():
	collision_shape.disabled = false
	ui.mouse_filter = Control.MOUSE_FILTER_STOP
	disabled_collision = false

func toggle_tooltip_show():
	if tooltip_container.get_children() == []: return
	var mouse_pos = get_viewport().get_mouse_position()
	var correction = true
	var x_offset = 90
	var y_offset = -75
	tooltip.size = tooltip_container.size
	tooltip.visible = true
	
	#Toggles when mouse is on LEFT side of screen
	if mouse_pos.x <= get_viewport_rect().size.x/2: correction = false
	
	if correction == false:
		#tooltip.popup(Rect2i(get_parent().position + Vector2(x_offset, y_offset), size)) 
		tooltip.position = Vector2(x_offset, y_offset)
	else:
		#tooltip.popup(Rect2i(get_parent().position, size)) 
		tooltip.position = Vector2(-x_offset - tooltip.size.x, y_offset)

func toggle_tooltip_hide():
	tooltip.visible = false
	#tooltip.hide()

func update_tooltip(category, identifier, body = null, header = null):
	var temp
	for i in tooltip_container.get_children():
		if i.name == category: 
			temp = i
	if temp == null:
		var new_tooltip = load("res://Scenes/UI/Tooltips/tooltip_bg.tscn").instantiate()
		tooltip_container.add_child(new_tooltip)
		new_tooltip.create_tooltip(category, identifier, body, header)
	else:
		temp.update_tooltip(category, identifier, body, header)
