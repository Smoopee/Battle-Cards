extends Node2D

@export var card_stats_resource: Cards_Resource

@onready var card_stats 

signal hovered_on
signal hovered_off

var card_slotted = false
var is_discarded = false
var disabled_collision = false
var mouse_exit = false
var card_being_dragged = false

func _ready():
	set_stats(card_stats_resource)

func set_stats(stats = Cards_Resource) -> void:
	var card_stats_resource: Cards_Resource = preload("res://Resources/Cards/blank.tres")
	card_stats = card_stats_resource

func on_start(board):
	pass

func effect(player_deck, enemy_deck, player, enemy):
	pass

func upgrade_card(num):
	pass

func item_enchant(enchant):
	pass

func update_card_ui():
	pass

func update_card_image():
	$UpgradeBorder.texture = load(card_stats.card_art_path)
	$Panel/Label.text = str(card_stats.dmg)

func disable_collision():
	$Area2D/CollisionShape2D.disabled = true
	$CardUI.mouse_filter = Control.MOUSE_FILTER_IGNORE
	disabled_collision = true
	
func enable_collision():
	$Area2D/CollisionShape2D.disabled = false
	$CardUI.mouse_filter = Control.MOUSE_FILTER_STOP
	disabled_collision = false

func attack_animation(user):
	pass

