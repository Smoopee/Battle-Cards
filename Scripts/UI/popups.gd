extends Control

func card_popup(slot : Rect2i, card : Cards_Resource):
	return
	set_value(card)
	
	var mouse_pos = get_viewport().get_mouse_position()
	var correction 
	
	if mouse_pos.x <= get_viewport_rect().size.x/1.3:
		#Changes padding from card -> tool tip, Higher number is less padding
		correction = Vector2i(slot.size.x - 40, 0)
	else:
		correction = -Vector2i(%CardPopup.size.x + 55, 0)
	
	
	%CardPopup.popup(Rect2i(slot.position + correction, %CardPopup.size))
	%CardPopup.position += Vector2i(0, -80)
	
func hide_card_popup():
	return
	%CardPopup.hide()

func set_value(card: Cards_Resource):
	%Name.text = card.name

func talent_popup(slot, talent_name, effect):
	return
	set_talent_values(talent_name, effect)
	
	var mouse_pos = get_viewport().get_mouse_position()
	var correction 
	
	if mouse_pos.x <= get_viewport_rect().size.x/1.3:
		#Changes padding from card -> tool tip, Higher number is less padding
		correction = Vector2i(slot.size.x , 0)
	else:
		correction = -Vector2i(%TalentPopup.size.x + 55, 0)
	
	%TalentPopup.popup(Rect2i(slot.position + correction, Vector2i(100,100)))
	%TalentPopup.position += Vector2i(0, 380)

func set_talent_values(talent_name, effect):
	$UI/TalentPopup/VBoxContainer/Name.text = str(talent_name)
	$UI/TalentPopup/VBoxContainer/HBoxContainer/Information.text = str(effect)

func hide_talent_popup():
	return
	%TalentPopup.hide()
