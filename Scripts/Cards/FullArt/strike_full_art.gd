extends Node2D

var card_stats
var effect_details


func fill_info():
	
	$Panel/VBoxContainer/Name.text = str(card_stats.name)
	$Panel/VBoxContainer/EffectContainer/Label.text = str(effect_details)
	$Panel/VBoxContainer/CDContainer/Label.text = str(card_stats.cd)
	$Panel/VBoxContainer/CDRemainingCont/Label.text = str(card_stats.cd_remaining)
	
	
	$Panel.position =  Vector2(400, -400)
	$Panel.size = $Panel/VBoxContainer.size + Vector2(20, 20)
	$Panel/VBoxContainer.position = Vector2(10, 10)
