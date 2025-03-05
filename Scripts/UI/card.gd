extends Node2D

signal hoovered
signal hoovered_off

var hand_position
var card_slotted = false
var card_name = ""
var path = ""
var is_players = false
var card_position
var card_resource


func _ready():
	var card_manager = (get_tree().get_nodes_in_group("card manager")[0])
	card_manager.connect_card_signals(self)

func _on_area_2d_mouse_entered():
	emit_signal("hoovered", self)

func _on_area_2d_mouse_exited():
	emit_signal("hoovered_off", self)
	
func update_card_image():
	$CardImage.texture = load(card_resource.card_art_path)

func change_item_enchant_image():
	var enchant = card_resource.item_enchant
	
	if enchant == "Bleed":
		$CardUI/HBoxContainer/ItemEnchantImage.texture = load("res://Resources/UI/ItemEnhancement/bleed_enhancement.png")

func change_card_dmg_text():
	$CardUI/HBoxContainer/CardDamage.text = str(card_resource.dmg)

func card_shop_ui():
	if card_resource.is_players:
		$CardUI/SellPrice.text = str(card_resource.sell_price) + "g"
		$CardUI/BuyPrice.text = ""
	
	if !card_resource.is_players:
		$CardUI/BuyPrice.text = "- " + str(card_resource.buy_price) + "g"
		$CardUI/SellPrice.text = ""

func update_card_ui():
	update_card_image()
	change_item_enchant_image()
	change_card_dmg_text()
	

