extends Node2D

class_name Modifier

signal modifier_removed
signal counter_changed

var modifier_image : Sprite2D
var effect : Node2D
var attached_to : Node2D
var count : int = 0

func _ready():
	set_node_names()

func modifier_initializer(source):
	attached_to = source
	effect.initialize(source)

func additional_modifier(source):
	effect.additional_modifier(source)

func set_counter(amount):
	count = amount
	emit_signal("counter_changed", count)
	if count <= 0: remove_modifier()

func change_counter(amount):
	count += amount
	emit_signal("counter_changed", count)
	if count <= 0: remove_modifier()

func remove_modifier():
	emit_signal("modifier_removed", attached_to)
	queue_free()

func set_node_names():
	effect = get_node('%Effect')
	modifier_image = get_node('%ModifierImage')
	
	#z_index = 1
	add_to_group("modifier")
