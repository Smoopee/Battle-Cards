extends Node2D

var rune_stats: Runes_Resource = null
var rune_name = "Concealed"


func _ready():
	$PopupPanel/VBoxContainer/Name.text = rune_name
	update_tooltip("Effect","WIP",  "Effect: ")
	print(rune_stats)
	if rune_stats == null: return
	if rune_stats.attached != true: return
	
	if get_tree().get_first_node_in_group("enemy deck") != null:
		get_tree().get_first_node_in_group("enemy deck").connect("build_enemy_deck", rune_effect1)
	
	if get_tree().get_first_node_in_group("battle sim") != null:
		get_tree().get_first_node_in_group("battle sim").connect("start_of_round", rune_effect2)
		
	if get_tree().get_first_node_in_group("enemy") != null:
		if get_tree().get_first_node_in_group("enemy").has_signal("generate_reward"):
			get_tree().get_first_node_in_group("enemy").connect("generate_reward", reward)

func rune_effect1():
	var conceal_card = load("res://Resources/Cards/CardArt/concealed_card.png")
	for i in get_tree().get_first_node_in_group("enemy deck").get_children():
		if i.is_in_group("card"):
			i.get_node("CardImage").texture = conceal_card
			i.get_node("ItemEnchantImage").visible = false
			i.get_node("UpgradeBorder").visible = false
			i.get_node("CardUI").visible = false

func rune_effect2():
	for i in get_tree().get_first_node_in_group("enemy deck").get_children():
		if i.is_in_group("card"):
			i.get_node("CardImage").texture = load(i.card_stats.card_art_path)
			i.upgrade_card(i.card_stats.upgrade_level)
			i.item_enchant(i.card_stats.item_enchant)
			i.get_node("ItemEnchantImage").visible = true
			i.get_node("UpgradeBorder").visible = true
			i.get_node("CardUI").visible = true

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




