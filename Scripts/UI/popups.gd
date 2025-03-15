extends Control

func card_popup(slot : Rect2i, card : Cards_Resource):
	set_value(card)
	
	var mouse_pos = get_viewport().get_mouse_position()
	var correction 
	
	
	if mouse_pos.x <= get_viewport_rect().size.x/2:
		correction = Vector2i(slot.size.x - 30, 0)
	else:
		correction = -Vector2i(%CardPopup.size.x + 55, 0)
	
	%CardPopup.popup(Rect2i(slot.position + correction, %CardPopup.size))
	
func hide_card_popup():
	%CardPopup.hide()

func set_value(card: Cards_Resource):
	%Name.text = card.name
