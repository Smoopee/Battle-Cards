extends Node2D

signal scene_change

var current_scene: String = ""
var next_scene: String = ""

var is_pre_battle = false

func _ready():
	add_scene("res://Scenes/UI/TitleScreen/title_screen.tscn")

func add_scene(scene_path):
	var new_scene = load(scene_path).instantiate()
	add_child.call_deferred(new_scene)
	emit_signal("scene_change", Global.current_scene)

func scene_transition(alpha, duration):
	await $Fader.fade(alpha, duration).finished
	$Fader.color_rect.color.a = 0.0
