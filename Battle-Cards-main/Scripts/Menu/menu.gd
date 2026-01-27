extends CanvasLayer

@onready var combat_speed_slider = $BGDimmer/BGForRewardBox/VBoxContainer/VBoxContainer/CombatSpeedSlider

func _ready() -> void:
	$BGDimmer.size = get_viewport().size
	Global.COMBAT_SPEED = .8 / combat_speed_slider.value

func _on_new_game_button_down() -> void:
	Global.current_scene == "start_screen"
	await get_tree().get_first_node_in_group("main").scene_transition(1, 1.0)
	get_tree().get_first_node_in_group("main").add_scene("res://Scenes/UI/StartScreen/start_screen.tscn")
	get_tree().get_first_node_in_group("current scene").queue_free()
	self.visible = false
	self.process_mode = Node.PROCESS_MODE_DISABLED



func _on_close_menu_button_down() -> void:
	Global.COMBAT_SPEED = .8 / combat_speed_slider.value
	get_tree().get_first_node_in_group("current scene").process_mode = Node.PROCESS_MODE_INHERIT
	self.visible = false
	self.process_mode = Node.PROCESS_MODE_DISABLED
