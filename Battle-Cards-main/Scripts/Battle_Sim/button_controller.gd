extends Control



func _ready() -> void:
	show_start_button()
	for i in get_children():
		i.position = Vector2(get_viewport().size.x - 200, 
		Global.center_screen_y)


func show_start_button():
	$StartButton.visible = true
	$InterruptContinueButton.visible = false
	$ContinueButton.visible = false

func show_continue_button():
	$StartButton.visible = false
	$InterruptContinueButton.visible = false
	$ContinueButton.visible = true

func show_interrupt_button():
	$StartButton.visible = false
	$InterruptContinueButton.visible = true
	$ContinueButton.visible = false

func hide_buttons():
	$StartButton.visible = false
	$InterruptContinueButton.visible = false
	$ContinueButton.visible = false
