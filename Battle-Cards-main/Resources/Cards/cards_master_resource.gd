extends Resource

class_name Cards_Resource

@export var card_art_path: String
@export var full_art_scene_path: String
@export var full_art_texture_path: String
@export var card_border_path : String
@export var card_scene_path: String
@export var card_upgrade_art_path: String
@export var buff_scene_path: String
@export var name: String
@export var dmg: int
@export var cd: int
@export var cd_remaining: int
@export var on_cd: bool
@export var priority: int
@export var effect1: int
@export var effect2: int
@export var effect3: int
@export var effect4: int
@export var effect5: int
@export var buff_count: int
@export var debuff_count: int
@export var position: int
@export var inventory_position: int
@export var deck_position: int
@export var upgrade_level: int
@export var burn_dmg: int
@export var poison_dmg: int
@export var bleed_dmg: int
@export var heal: int
@export var critical_strike_chance: float
@export var in_enemy_deck: bool
#@export var block : int
@export var sell_price: int
@export var buy_price: int
@export var is_players: bool
@export var item_enchant: String
@export var screen_position: Vector2
@export var is_enchanted : bool
@export var tags: Array
@export var card_type: Array
@export var is_discarded: bool
@export var is_blank: bool
@export var is_updated: bool
@export var mode: String
@export var card_rarity: int
var owner
var target
var dejavu_used = false
var prosperity: int
