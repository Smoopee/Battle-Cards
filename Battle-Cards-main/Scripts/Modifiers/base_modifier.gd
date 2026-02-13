extends Node2D

class_name Modifier

signal modifer_removed
signal counter_changed

@onready var modifier_stats = get_parent().modifier_stats

var modifier_image: Sprite2D
var modifier_counter: Label
var modifier_counter_panel: Panel

func _ready():
	set_node_names()

func set_node_names():
	modifier_counter = get_node('%ModifierCounters')
	modifier_counter_panel = get_node('%ModifierCounterPanel')
	modifier_image = get_node('%ModifierImage')
	modifier_image.texture = load(modifier_stats.modifier_art_path)
	z_index = 1
	add_to_group("modifier")

func set_counter(amount):
	modifier_stats.count = amount
	modifier_counter.text = str(modifier_stats.count)
	emit_signal("counter_changed", modifier_stats.count)

func change_counter(amount):
	modifier_stats.count += amount
	modifier_counter.text = str(modifier_stats.count)
	emit_signal("counter_changed", modifier_stats.count)

func remove_modifier():
	emit_signal("modifier_removed")
	queue_free()
