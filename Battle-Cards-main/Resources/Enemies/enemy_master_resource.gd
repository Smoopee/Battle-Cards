extends Resource

class_name Enemy_Resource

@export var enemy_art_path: String
@export var enemy_border_art_path: String
@export var enemy_scene_path: String
@export var name: String
@export var health: int
@export var max_health: int
@export var stagger: int
@export var max_stagger: int
@export var xp: int
@export var gold: int
@export var bleeding_dmg: int
@export var burning_dmg: int
@export var poisoning_dmg: int
@export var attack: int
@export var defense: int
@export var block: int
@export var speed: int
@export var is_stunned: bool
@export var stun_counter: int
@export var runes: Array
@export var biomes: Array
@export var selection_tags: Array
@export var card_pool: Array

var can_be_stunned = true
var can_be_staggered = true
var can_gain_stagger = true
var staggered_counter: int
