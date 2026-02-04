extends CanvasLayer

var screen = ""

func _ready() -> void:
	$ColorRect.size.x = get_viewport().size.x
	$ColorRect.size.y = 45
	$ColorRect.position.y = 0
	
	$ColorRect/PlayerUI.position.x += 50
	$ColorRect/HBoxContainer.position.x -= 100
	
func _on_talent_button_button_down():
	toggle_talent_screen()


func _on_back_button_button_down():
	if screen == "talents":
		get_tree().get_first_node_in_group("talent tree").visible = false
		$ColorRect/HBoxContainer/TalentButton.visible = true
		$ColorRect/HBoxContainer/MenuButton.visible = true
		$ColorRect/HBoxContainer/BackButton.visible = false
		
		screen = ""

func talent_alert_toggle(toggle):
	if toggle:
		$ColorRect/HBoxContainer/TalentButton/AlertIndicator.visible = true
	else: 
		$ColorRect/HBoxContainer/TalentButton/AlertIndicator.visible = false

func change_player_gold():
	$ColorRect/PlayerUI.change_player_gold()
	
func toggle_talent_screen():
	get_tree().get_first_node_in_group("talent tree").visible = true
	$ColorRect/HBoxContainer/TalentButton.visible = false
	$ColorRect/HBoxContainer/MenuButton.visible = false
	$ColorRect/HBoxContainer/BackButton.visible = true
	screen = "talents"

func _on_menu_button_down() -> void:
	get_tree().get_first_node_in_group("current scene").process_mode = Node.PROCESS_MODE_DISABLED
	get_tree().get_first_node_in_group("menu").visible = true
	get_tree().get_first_node_in_group("menu").process_mode = Node.PROCESS_MODE_INHERIT


func change_gold(gold):
	Global.player_gold += gold
	$ColorRect/PlayerUI.change_player_gold()
