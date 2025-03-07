extends Resource

class_name Cards_Resource

@export var card_art_path: String
@export var card_scene_path: String
@export var name: String
@export var dmg: int
@export var position: int
@export var inventory_position: int
@export var deck_position: int
@export var upgrade_level: int
@export var burn_dmg: int
@export var poison_dmg: int
@export var bleed_dmg: int
@export var shield: int
@export var heal: int
@export var critical_strike_chance: float
@export var in_enemy_deck: bool
@export var temp_buff: bool
@export var block : int
@export var sell_price: int
@export var buy_price: int
@export var is_players: bool
@export var item_enchant: String
@export var screen_position: Vector2
@export var is_enchanted : bool
@export var is_enchantment: bool
@export var enchanting_with: String
@export var card_type: String
@export var is_discarded: bool

func effect():
	pass

func on_start():
	pass
