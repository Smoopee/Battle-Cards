extends Node2D

@onready var stats = gadget_stats
@onready var gadget = $BaseGadget

var gadget_stats: Gadgets_Resource = null

func gadget_signal_connect(scene):
	if scene == "shop":
		gadget_effect()

func gadget_effect():
	Global.current_merchant.stock_quantity += 1


func upgrade_gadget(num):
	match num:
		1:
			stats.gadget_upgrade_art_path = "res://Resources/Art/Skills/skill_upgrade1.png"
			stats.upgrade_level = 1
			stats.buy_price = 2
		2: 
			stats.gadget_upgrade_art_path = "res://Resources/Art/Skills/skill_upgrade2.png"
			stats.upgrade_level = 2
			stats.buy_price = 4
		3:
			stats.gadget_upgrade_art_path = "res://Resources/Art/Skills/skill_upgrade3.png"
			stats.upgrade_level = 3
			stats.buy_price = 8
		4:
			stats.gadget_upgrade_art_path = "res://Resources/Art/Skills/skill_upgrade4.png"
			stats.upgrade_level = 4
			stats.buy_price = 16
	
	gadget.update_tooltip(str(stats.name), 
	"Effect", 
	"At 20% Health, Increase Atk by " + str(stats.effect1), 
	"Effect: ")
	gadget.update_gadget_image()
