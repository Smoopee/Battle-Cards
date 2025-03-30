extends Node2D

var enemy_skills = []

var paper_shield = preload("res://Scenes/Skills/paper_shield.tscn")
var right_on_time = preload("res://Scenes/Skills/right_on_time.tscn")
var third_wheel = preload("res://Scenes/Skills/third_wheel.tscn")

func _ready():
	return
	enemy_skills.push_back(paper_shield)
	enemy_skills.push_back(right_on_time)
	enemy_skills.push_back(third_wheel)
