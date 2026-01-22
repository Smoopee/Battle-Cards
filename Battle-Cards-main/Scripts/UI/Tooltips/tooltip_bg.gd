extends Panel

@onready var hbox = $VBoxContainer/HBoxContainer
@onready var vbox = $VBoxContainer
@onready var category_label = $VBoxContainer/Category
@onready var header_label = $VBoxContainer/HBoxContainer/Header
@onready var body_label = $VBoxContainer/HBoxContainer/Body

var hbox_array = []


func _ready():
	hbox_array.push_back(hbox)
	var size_correction
	size_correction = Vector2(category_label.size.y, 0) + body_label.size
	custom_minimum_size = size_correction

func create_tooltip(category, identifier, body = null, header = null):
	
	match category:
		"Enchantment":
			enchantment_tooltip(category, identifier, body, header)
		"Modifier":
			modifier_tooltip(category, identifier, body, header)
		_:
			effect_tooltip(category, identifier, body, header)
	
func enchantment_tooltip(category, identifier, body = null, header = null):
	name = category
	category_label.text = str(category)
	header_label.text = str(header)
	body_label.text = str(body)
	
	sizing_function()
	add_panel_spacer()

func modifier_tooltip(category, identifier, body = null, header = null):
	name = category
	category_label.text = str(category)
	header_label.text = str(header)
	body_label.text = str(body)
	body_label.name = identifier
	
	sizing_function()
	add_panel_spacer()

func effect_tooltip(category, identifier, body = null, header = null):
	name = category
	category_label.text = str(category)
	header_label.text = str(header)
	body_label.text = str(body)
	
	sizing_function()
	add_panel_spacer()

func sizing_function():
	var total_height = 0
	var biggest_width = 0
	var width_array = []
	var height_array = []
	var height1 = 0
	var height2 = 0
	
	var category_size = category_label.get_minimum_size()
	width_array.push_back(category_size.x)
	
	for j in hbox_array:
		var total_width = 0
		for i in j.get_children():
			var font : Font = i.get_theme_font("font")
			var temp_size = i.get_minimum_size()
			
			height1 = temp_size.y  
			if height1 > height2:
				height2 = height1
			
			total_width += temp_size.x
		
		height_array.push_back(height2)
		width_array.push_back(total_width)
	
	total_height = sum_height_array(height_array)
	biggest_width = width_array.max()

	
	var size_correction
	size_correction = Vector2(biggest_width, total_height) + Vector2(0, 40)
	custom_minimum_size = size_correction
	get_parent().custom_minimum_size = size_correction
	get_parent().get_parent().size = size_correction

func sum_height_array(array):
	var sum = 0.0
	for i in array:
		sum += i
	return sum

func add_panel_spacer():
	var panel = Panel.new()
	panel.custom_minimum_size = Vector2(0, 30)
	panel.self_modulate.a = 0
	get_parent().add_child(panel)

func update_tooltip(category, identifier, body = null, header = null):
	match category:
		"Enchantment":
			update_enchantment_tooltip(category, identifier, body, header)
		"Modifier":
			update_modifier_tooltip(category, identifier, body, header)
		_:
			update_effect_tooltip(category, identifier, body, header)

func update_effect_tooltip(category, identifier, body = null, header = null):
	name = category
	category_label.text = category
	header_label.text = str(header)
	body_label.text = str(body)
	
	sizing_function()

func update_enchantment_tooltip(category, identifier, body = null, header = null):
	name = category
	header_label.text = str(header)
	body_label.text = str(body)
	sizing_function()

func update_modifier_tooltip(category, identifier, body = null, header = null):
	var temp
	for j in hbox_array:
		for i in j.get_children():
			if i.name == str(identifier):
				temp = i
				temp.text = str(body)

	if temp == null:
		create_new_modifier_tooltip(category, identifier, body, header)

func create_new_modifier_tooltip(category, identifier, body = null, header = null):
	var new_modifier = load("res://Scenes/UI/Tooltips/add_modifier_tooltip.tscn").instantiate()
	new_modifier.add_modifier_tooltip(category, identifier, body, header)
	vbox.add_child(new_modifier)
	hbox_array.push_front(new_modifier)
	sizing_function()
