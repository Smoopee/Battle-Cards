extends Node2D

var rune_stats: Runes_Resource = null
var rune_name = "Growing"


func _ready():
	$PopupPanel/VBoxContainer/Name.text = rune_name
	update_tooltip("Effect","WIP",  "Effect: ")

func connect_rune():
	if get_tree().get_first_node_in_group("battle sim") != null:
		get_tree().get_first_node_in_group("battle sim").connect("start_of_battle", rune_effect1)

func rune_effect1():
	print("In rune of growing effect")
	var enemy = get_tree().get_first_node_in_group("enemy")
	enemy.change_attack(10)
	enemy.character_stats.max_health *= 1.5
	enemy.set_stat_container()
	Global.enemy_health *= 1.5
	Global.max_enemy_health *= 1.5
	enemy.change_enemy_health()
	


func reward():
	#Global.current_enemy.gold += 1000
	
	#for i in get_tree().get_first_node_in_group("enemy").reward_array:
		#if i.get_script() == load("res://Resources/Cards/cards_master_resource.gd"):
			#i.item_enchant = "Bleed"
	
	#for i in get_tree().get_first_node_in_group("enemy").reward_array:
		#get_tree().get_first_node_in_group("enemy").reward_array = [load("res://Resources/Cards/strike.tres")]
	
	for i in get_tree().get_first_node_in_group("enemy").reward_array:
		get_tree().get_first_node_in_group("enemy").reward_array = [load("res://Resources/Skills/third_wheel.tres")]
	
	print("Here is your concealed reward")

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

func rune_shop_ui():
	if rune_stats.rune_owner != get_tree().get_first_node_in_group("character"):
		$RuneUI/ShopPanel/ShopLabel.text =  str(rune_stats.buy_price)

func toggle_shop_ui(show):
	if show: $RuneUI/ShopPanel.visible = true
	if Global.current_scene == "shop": return
	if !show: $RuneUI/ShopPanel.visible = false




