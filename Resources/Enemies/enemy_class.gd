extends Node2D

class_name Enemy

signal generate_reward
signal health_changed
signal physical_damage_dealt
signal physical_damage_taken
signal bleeding_damage_applied
signal bleeding_damage_taken
signal burning_damage_applied
signal burning_damage_taken
signal poisoning_damage_applied
signal poisoning_damage_taken
signal heal_received


const SKILL_X_POSITION = 600
const SKILL_Y_POSITION = 0
const RUNE_X_POSITION = -75
const RUNE_Y_POSITION = -60

var enemy_image : Sprite2D
var enemy_border : Sprite2D
var enemy_buffs : Node2D
var enemy_debuffs : Node2D
var runes : Node2D
var enemy_deck : Node2D
var skills : Node2D
var enemy_ui : Control
var enemy_health_bar : TextureProgressBar
var enemy_health_label : Label
var gold_and_xp_box : VBoxContainer
var enemy_gold : Label
var enemy_xp : Label
var enemy_selection_hp_bar : TextureProgressBar
var enemy_selection_hp_label : Label
var stat_container : VBoxContainer
var attack_label : Label
var attack_panel : Panel
var defense_label : Label
var defense_panel : Panel
var armor_label : Label
var armor_panel : Panel
var stun_indicator : Panel
var stun_label : Label

var character_stats = null

var reward_array = []
var difficulty_level
var deck

#COMBAT VARIABLES==================================================================================
var receiving_physical_dmg = 0
var dealing_physical_dmg = 0
var temp_physical_damage = 0

func _ready():
	set_node_names()
	set_stats()
	set_deck()
	set_stat_container()
	set_runes()
	set_enemy_gold()
	set_enemy_xp()

func setup():
	set_stat_container()
	set_skills()
	set_runes()

func set_stats() -> void:
	adjust_stats()

func set_stat_container():
	attack_label.text = "Atk: " + str(character_stats.attack)
	defense_label.text = "Def: " + str(character_stats.defense)
	armor_label.text = "Armor: " +  str(character_stats.armor)
	
	enemy_health_bar.max_value = character_stats.max_health
	enemy_health_bar.value = character_stats.max_health
	enemy_health_label.text = str(enemy_health_bar.value) + "/" + str(enemy_health_bar.max_value)
	enemy_selection_hp_label.text = str(enemy_health_bar.value) + "/" + str(enemy_health_bar.max_value)

#SIGNALS ===========================================================================================
func connect_signals(battle_sim):
	battle_sim.connect("end_of_turn", end_of_turn)
	battle_sim.connect("end_of_round", end_of_round)

func end_of_turn():
	bleed_damage_keeper()
	burn_damage_turn_keeper()
	poison_damage_keeper()
	stun_keeper()

func end_of_round(round):
	burn_damage_round_keeper()

#SKILLS=============================================================================================
func set_skills():
	for i in skills.enemy_skills:
		var new_instance = load(i.skill_scene_path).instantiate()
		new_instance.skill_stats = i
		new_instance.skill_stats.owner = self
		new_instance.skill_stats.target = get_tree().get_first_node_in_group("character")
		new_instance.upgrade_skill(new_instance.skill_stats.upgrade_level)
		skills.add_child(new_instance)
	
	organize_skills()

func organize_skills():
	var x_offset = 0
	for i in skills.get_children():
		i.position = Vector2(x_offset + SKILL_X_POSITION, SKILL_Y_POSITION)
		x_offset += 60

#RUNES==============================================================================================
func set_runes():
	var already_owned = false
	var rune_db_reference = preload("res://Resources/Runes/rune_db.gd")
	for i in character_stats.runes:
		
		for j in runes.get_children():
			if j.rune_name == i: already_owned = true
		
		if rune_db_reference.RUNES[i] != null and !already_owned:
			var rune_resource = load(rune_db_reference.RUNES[i]).duplicate()
			var rune_scene = load(rune_resource.rune_scene_path).instantiate()
			rune_scene.rune_stats = rune_resource
			runes.add_child(rune_scene)
			rune_scene.rune_stats.attached = true
			#rune_scene.connect_rune()
			
		already_owned = false
	orgainze_runes()

func add_rune(rune):
	character_stats.runes.push_back(rune)
	set_runes()

func orgainze_runes():
	var counter = 0
	var x_offset = 0
	var y_offset = 0
	
	for i in runes.get_children():
		if counter >= 5: 
			x_offset = -32
			y_offset = 0
			counter = 0
		i.position = Vector2(x_offset + RUNE_X_POSITION, y_offset + RUNE_Y_POSITION)
		y_offset += 30
		counter += 1

#BUFFS/DEBUFFS =====================================================================================
func add_buff(buff_resource, source):
	get_tree().get_first_node_in_group("enemy buffs").add_buff(buff_resource, source)

func remove_buff(buff):
	get_tree().get_first_node_in_group("enemy buffs").remove_buff(buff)

func add_debuff(debuff_resource, source):
	get_tree().get_first_node_in_group("enemy debuffs").add_debuff(debuff_resource, source)

func remove_debuff(debuff):
	get_tree().get_first_node_in_group("enemy debuffs").remove_debuff(debuff)



func set_deck():
	deck = enemy_deck.enemy_deck


#COMBAT FUNCTIONS ==================================================================================
func take_physical_damage(damage):
	receiving_physical_dmg = damage
	receiving_physical_dmg -= character_stats.armor
	receiving_physical_dmg -= character_stats.defense
	if character_stats.is_stunned: 
		receiving_physical_dmg *= 2
	if receiving_physical_dmg <= 0: receiving_physical_dmg = 0
	emit_signal("physical_damage_taken", receiving_physical_dmg)
	change_health(-receiving_physical_dmg)

func deal_physical_damage(damage):
	dealing_physical_dmg = damage
	dealing_physical_dmg += character_stats.attack + temp_physical_damage
	emit_signal("physical_damage_dealt", dealing_physical_dmg)
	temp_physical_damage = 0
	return dealing_physical_dmg

func deal_bleed_damage():
	pass

func apply_bleeding_damage(damage):
	emit_signal("bleeding_damage_applied", character_stats.bleeding_dmg + damage)
	character_stats.bleeding_dmg += damage

func bleed_damage_keeper():
	if character_stats.bleeding_dmg > 0:
		emit_signal("bleeding_damage_taken", character_stats.bleeding_dmg)
		change_health(-character_stats.bleeding_dmg)
		character_stats.bleeding_dmg -= 1

func deal_burn_damage():
	pass

func apply_burning_damage(damage):
	emit_signal("burning_damage_applied", character_stats.burning_dmg + damage)
	character_stats.burning_dmg += damage

func burn_damage_turn_keeper():
	if character_stats.burning_dmg > 0:
		emit_signal("burning_damage_taken", character_stats.burning_dmg)
		change_health(-character_stats.burning_dmg)

func burn_damage_round_keeper():
	if character_stats.burning_dmg > 0:
		character_stats.burning_dmg /= 2
		print(character_stats.burning_dmg)
		emit_signal("burning_damage_taken", character_stats.burning_dmg)

func deal_poison_damage():
	pass

func apply_poisoning_damage(damage):
	emit_signal("poisoning_damage_applied", character_stats.poisoning_dmg + damage)
	character_stats.poisoning_dmg += damage

func poison_damage_keeper():
	if character_stats.poisoning_dmg > 0:
		emit_signal("poisoning_damage_taken", character_stats.poisoning_dmg)
		change_health(-character_stats.poisoning_dmg)

func stun_keeper():
	if character_stats.stun_counter >= 1:
		character_stats.stun_counter -= 1
		stun_label.text = str(character_stats.stun_counter)
	
	if character_stats.stun_counter <= 0:
		stun_toggle(false)

func heal_function(amount):
	emit_signal("heal_received")
	change_health(amount)

func lifesteal(damage):
	heal_function(damage)

func change_health(amount):
	character_stats.health += amount
	if character_stats.health > character_stats.max_health: character_stats.health = character_stats.max_health
	enemy_health_bar.value = character_stats.health
	enemy_health_label.text = str(enemy_health_bar.value) + "/" + str(enemy_health_bar.max_value)
	emit_signal("health_changed")

func stun_toggle(toggle):
	if toggle: 
		stun_indicator.visible = true
		character_stats.is_stunned = true
		stun_label.text = str(character_stats.stun_counter)
	else: 
		stun_indicator.visible = false
		character_stats.is_stunned = false

#UI / STATS=========================================================================================
func set_enemy_gold():
	enemy_gold.text = str(character_stats.gold) + "g"

func set_enemy_xp():
	enemy_xp.text = str(character_stats.xp) + "xp"

func change_attack(amount):
	character_stats.attack += amount
	attack_label.text = "Atk: " + str(character_stats.attack) 

func change_defense(amount):
	character_stats.defense += amount
	defense_label.text = str(character_stats.defense)

func change_armor(amount):
	character_stats.armor += amount
	armor_label.text = str(character_stats.armor)

func change_max_health(amount):
	character_stats.max_health *= amount
	var health_difference = character_stats.max_health - character_stats.health
	character_stats.health = character_stats.max_health
	change_health(health_difference)
	set_stat_container()

func adjust_stats():
	var difficulty = set_difficulty()
	
	match difficulty:
		1:
			return
		2:
			change_attack(10)
			change_max_health(1.5)
		3:
			change_attack(20)
			change_max_health(2)
		4:
			change_attack(40)
			change_max_health(3)
		_:
			change_attack(70)
			change_max_health(5)

#Other==============================================================================================
func get_reward():
	var rng = RandomNumberGenerator.new()
	reward_array = enemy_deck.enemy_enemy_deck + skills.enemy_skills 
	emit_signal("generate_reward")
	
	var reward_index =  rng.randi_range(0, reward_array.size()-1)
	return reward_array[reward_index]

func active_enemy_deck_access():
	return Global.enemy_active_enemy_deck

func set_difficulty():
	var battle_number = Global.battle_tracker
	if battle_number <= 4:
		return 1
	elif battle_number <= 8:
		return 2
	elif battle_number <= 12:
		return 3
	elif battle_number <= 16:
		return 4
	else: return 5

func set_node_names():
	enemy_image = get_node('%EnemyImage')
	enemy_border = get_node('%EnemyBorder')
	enemy_buffs = get_node('%EnemyBuffs')
	enemy_debuffs = get_node('%EnemyDebuffs')
	runes = get_node('%Runes')
	enemy_deck = get_node('%Deck')
	skills = get_node('%Skills')
	enemy_ui = get_node('%EnemyUI')
	enemy_health_bar = get_node('%EnemyHealthBar')
	enemy_health_label = get_node('%EnemyHealthLabel')
	gold_and_xp_box = get_node('%GoldAndXPBox')
	enemy_gold = get_node('%EnemyGold')
	enemy_xp = get_node('%EnemyXP')
	enemy_selection_hp_bar = get_node('%EnemyHealthBar2')
	enemy_selection_hp_label = get_node('%EnemySelectionHealth')
	stat_container = get_node('%StatContainer')
	attack_label = get_node('%AttackLabel')
	attack_panel = get_node('%AttackPanel')
	defense_label = get_node('%DefenseLabel')
	defense_panel = get_node('%DefensePanel')
	armor_label = get_node('%ArmorLabel')
	armor_panel = get_node('%ArmorPanel')
	stun_indicator = get_node('%StunIndicator')
	stun_label = get_node('%StunLabel')
	
	enemy_image.texture = load(character_stats.enemy_art_path)
	enemy_border.texture = load(character_stats.enemy_border_art_path)
	z_index = 1
	add_to_group("enemy")

