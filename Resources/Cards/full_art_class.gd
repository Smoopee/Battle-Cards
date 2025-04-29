extends Node2D

class_name FullArt

var card_stats
var effect_details

var name_label : Label
var effect_label : Label
var cd_label : Label
var cd_remaining_label : Label
var details_bg : Panel
var details_container : VBoxContainer
var image : Sprite2D

func _ready():
	name_label = get_node('%Name')
	effect_label = get_node('%EffectLabel')
	cd_label = get_node('%CDLabel')
	cd_remaining_label = get_node('%CDRemainingLabel')
	details_bg = get_node('%DetailsBG')
	details_container = get_node('%DetailsContainer')
	image = get_node ('%FullArtImage')

func fill_info():
	z_index = 5
	
	image.texture = load(card_stats.full_art_texture_path)
	name_label.text = str(card_stats.name)
	effect_label.text = str(effect_details)
	cd_label.text = str(card_stats.cd)
	cd_remaining_label.text = str(card_stats.cd_remaining)
	
	
	details_bg.position =  Vector2(400, -400)
	details_bg.size = details_container.size + Vector2(20, 20)
	details_container.position = Vector2(10, 10)
