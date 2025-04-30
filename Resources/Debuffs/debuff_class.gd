extends Node2D

class_name Debuff

signal debuff_removed
signal counter_changed

var debuff_stats: Debuff_Resource = null

var debuff_image: Sprite2D
var debuff_counter: Label
var debuff_counter_panel: Panel
var effect: Node2D

func _ready():
	set_node_names()

func debuff_initializer(source):
	effect.initialize(source)

func additional_debuff(source):
	effect.additional_debuff(source)

func set_node_names():
	debuff_counter = get_node('%DebuffCounters')
	debuff_counter_panel = get_node('%DebuffCounterPanel')
	effect = get_node('%Effect')
	debuff_image = get_node('%DebuffImage')
	
	debuff_image.texture = load(debuff_stats.debuff_art_path)
	z_index = 1
	add_to_group("debuff")

func set_counter(amount):
	debuff_stats.count = amount
	debuff_counter.text = str(debuff_stats.count)
	emit_signal("counter_changed", debuff_stats.count)
	if debuff_stats.count <= 0: remove_debuff()

func change_counter(amount):
	debuff_stats.count += amount
	debuff_counter.text = str(debuff_stats.count)
	emit_signal("counter_changed", debuff_stats.count)
	if debuff_stats.count <= 0: remove_debuff()

func remove_debuff():
	emit_signal("debuff_removed")
	queue_free()
