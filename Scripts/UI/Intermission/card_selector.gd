extends Node2D


const CARD_WIDTH = 150
const HAND_Y_POSITION = 690
const CARD_SCENE_PATH = "res://Scenes/UI/card.tscn"

@onready var intermission = $".."

var center_screen_x

func _ready():
	center_screen_x = get_viewport().size.x / 2
	
	var card = preload("res://Scenes/UI/card.tscn")
	var card_scene = card
	var new_card = card_scene.instantiate()
	new_card.get_node("CardImage").texture = load("res://Resources/Art/UIElements/pointer.png")
	#intermission.call_deferred("add_child", new_card)
	add_child(new_card)
	var new_position = Vector2(center_screen_x, HAND_Y_POSITION)
	new_card.hand_position = new_position
	new_card.position = new_position

 
func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1)
	

func card_selector_collision_toggle():
	print("Children are " + str(get_children()))
	for i in get_children():
			if i.disabled_collision:
				i.enable_collision()
				print("enabled")
			else:
				i.disable_collision()
				print("disabled")
