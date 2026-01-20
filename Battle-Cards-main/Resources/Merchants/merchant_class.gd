extends Node2D

class_name Merchant

var inventory = []
var inventory_selection = []
var merchant_stats: Merchant_Resource = null
var db_reference

var tooltip : PopupPanel
var tooltip_container : VBoxContainer
var merchant_variables : Node2D
var merchant_image : Sprite2D
var border_image : Sprite2D

func _ready():
	set_node_names()
	get_db_reference()
	add_to_group("merchant")
	merchant_variables.tooltip_merchant()
	self.scale = Global.ui_scaler

func set_node_names():
	merchant_variables = get_node('%MerchantVariables')
	merchant_image = get_node('%MerchantImage')
	border_image = get_node('%BorderImage')
	tooltip = get_node('%PopupPanel')
	tooltip_container = get_node('%TooltipContainer')
	
	merchant_image.texture = load(merchant_stats.merchant_art_path)
	border_image.texture = load(merchant_stats.merchant_border_path)

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
		"Enchantment":
			db_reference = preload("res://Resources/Enchantments/enchantment_db.gd")

func get_inventory():
	inventory = []
	inventory_selection = []
	get_inventory_selection()
	create_inventory()
	
	if merchant_stats.merchant_type == "Skill" or merchant_stats.merchant_type == "Card":
		item_upgrade_function()

func get_inventory_selection():
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
	return inventory_selection[item_selection_index]

func item_upgrade_function():
	var rng = RandomNumberGenerator.new()
	
	for i in inventory:
		var upgrade_calc = rng.randi_range(0, 99)
		if upgrade_calc >= 96: i.upgrade_level = 4
		elif upgrade_calc >= 69: i.upgrade_level = 3
		elif upgrade_calc >= 49: i.upgrade_level = 2
		elif upgrade_calc >= 0: i.upgrade_level = 1

#WIP TOOLTIPS======================================================================================
func toggle_tooltip_show():
	if tooltip_container.get_children() == []: return
	var mouse_pos = get_viewport().get_mouse_position()
	var correction = true
	var size = Vector2i(0,0)
	var x_offset = 85
	var y_offset = -105
	
	#Toggles when mouse is on right side of screen
	if mouse_pos.x <= get_viewport_rect().size.x/2: correction = false
	
	if correction == false:
		tooltip.popup(Rect2i(global_position + Vector2(x_offset, y_offset), size)) 
	else:
		var new_position = global_position + Vector2(-x_offset - tooltip.size.x , y_offset)
		tooltip.popup(Rect2i(new_position, size)) 
		

func toggle_tooltip_hide():
	tooltip.hide()

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

func _on_merchant_ui_mouse_entered():
	if get_tree().get_first_node_in_group("card manager").card_being_dragged != null: return
	scale = Vector2(1.1, 1.1) * Global.ui_scaler
	toggle_tooltip_show()

func _on_merchant_ui_mouse_exited():
	scale = Vector2(1, 1) * Global.ui_scaler
	toggle_tooltip_hide()
