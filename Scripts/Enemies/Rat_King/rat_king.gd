extends Node2D

@export var enemy_stats_resource: Enemy_Resource

@onready var enemy_deck = $Deck.enemy_deck
@onready var enemy_skills = $Skills.enemy_skills

var enemy_stats: Enemy_Resource = null

var enemy_scene_path = "res://Scenes/Enemies/rat_king.tscn"
var enemy_resource_path = "res://Resources/Enemies/rat_king.tres"

func _ready():
	set_stats(enemy_stats_resource)

func set_stats(stats = Enemy_Resource) -> void:
	enemy_stats = stats
