extends Node2D

var enemy_skills = []

var honed_edge = preload("res://Scenes/Skills/hone_edged.tscn")

func _ready():
	enemy_skills.push_back(honed_edge)
