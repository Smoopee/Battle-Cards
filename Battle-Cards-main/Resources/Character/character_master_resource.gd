extends Resource

class_name Character_Resource

@export var character_art_path: String
@export var character_scene_path: String
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
@export var rage: int
@export var max_rage: int
@export var speed: int
@export var is_stunned: bool
@export var stun_counter: int

var can_be_stunned = true
var can_be_staggered = true
var can_gain_stagger = true
var staggered_counter: int
