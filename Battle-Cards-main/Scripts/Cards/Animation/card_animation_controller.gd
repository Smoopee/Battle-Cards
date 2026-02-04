extends Node2D

@onready var audio = %AudioStreamPlayer2D
@onready var base_card = $".."

var rng = RandomNumberGenerator.new()
var start_position

var attack_tween
func _attack_animation(owner):
	attack_tween = get_tree().create_tween()
	if owner.is_in_group("enemy"):
		attack_tween.tween_property(base_card, "position", position + Vector2(0, 64), .5 * Global.COMBAT_SPEED )
		attack_tween.tween_property(base_card, "position", position + Vector2(0, 0), .5 * Global.COMBAT_SPEED )
	else:
		attack_tween.tween_property(base_card, "position", position + Vector2(0, -64), .5 * Global.COMBAT_SPEED )
		attack_tween.tween_property(base_card, "position", position + Vector2(0, 0), .5 * Global.COMBAT_SPEED )
		await attack_tween.finished
		audio.stream 
		audio.play()

var pre_battle_tween
func _pre_battle_animation(owner):
	if base_card.card_stats.dmg <= 0 or base_card.card_stats.on_cd: return
	start_position = base_card.position
	var speed_variance = rng.randf_range(1, 1.2)
	pre_battle_tween = get_tree().create_tween()
	pre_battle_tween.set_loops()
	if owner.is_in_group("enemy"):
		pre_battle_tween.tween_property(base_card, "position", position + Vector2(0, 20), 5 * speed_variance * Global.COMBAT_SPEED )
		pre_battle_tween.tween_property(base_card, "position", position + Vector2(0, 0), 5 * speed_variance * Global.COMBAT_SPEED )
	else:
		pre_battle_tween.tween_property(base_card, "position", position + Vector2(0, -20), 5 * speed_variance * Global.COMBAT_SPEED )
		pre_battle_tween.tween_property(base_card, "position", position + Vector2(0, 0), 5 * speed_variance * Global.COMBAT_SPEED )
	

func stop_pre_battle_animation(owner):
	if pre_battle_tween != null:
		pre_battle_tween.kill()
		base_card.position = start_position
