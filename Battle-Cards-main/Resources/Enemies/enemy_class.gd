extends Node2D

#class_name Enemy
signal stagger_changed
signal staggered
signal attack_changed
signal defense_changed
signal stunned
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

@onready var character_stats = get_parent().character_stats
@onready var glow_effect = $GlowEffect


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
var enemy_stagger_bar : TextureProgressBar
var enemy_stagger_label : Label
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
var speed_label : Label
var speed_panel : Panel
var stun_indicator : Panel
var stun_label : Label
var tooltip : Panel
var tooltip_container : VBoxContainer
var tooltip_layer : CanvasLayer
var glow_power = 3.0
var speed = 2.0

var reward_array = []
var difficulty_level
var deck

#COMBAT VARIABLES==================================================================================
var receiving_physical_dmg = 0
var dealing_physical_dmg = 0
var temp_physical_damage = 0

func _ready():
	self.scale = Global.ui_scaler
	add_to_group("enemy")
	set_node_names()
	if Global.current_scene != "battle_sim":
		%Skills.visible = false
		%Skills.process_mode = Node.PROCESS_MODE_DISABLED
	else: 
		%Skills.visible = true
		%Skills.process_mode = Node.PROCESS_MODE_INHERIT
		enemy_stagger_bar.visible = true
		enemy_stagger_bar.max_value = character_stats.max_stagger
		enemy_stagger_bar.value = character_stats.stagger
		enemy_stagger_label.text = str(int(enemy_stagger_bar.value)) + "/" + str(int(enemy_stagger_bar.max_value))
	runes.instantiate_runes()

func _process(delta):
	if glow_effect:
		glow_power += delta * speed
		if glow_power >= 2.0 and speed > 0 or glow_power <= 1.0 and speed < 0:
			speed *= -1.0
		$GlowEffect.modulate.a = glow_power/ 4
		$GlowEffect.get_material().set_shader_parameter("glow_power", glow_power)

func setup():
	set_stat_container()

func set_stats() -> void:
	adjust_stats()

func set_stat_container():
	attack_label.text = "Atk: " + str(character_stats.attack)
	defense_label.text = "Def: " + str(character_stats.defense)
	speed_label.text = "Spd: " +  str(character_stats.speed)
	
	enemy_health_bar.max_value = character_stats.max_health
	enemy_health_bar.value = character_stats.max_health
	enemy_health_label.text = str(int(enemy_health_bar.value)) + "/" + str(int(enemy_health_bar.max_value))
	enemy_selection_hp_label.text = str(int(enemy_health_bar.value))

#SIGNALS ===========================================================================================
func connect_signals(battle_sim):
	battle_sim.connect("end_of_turn", end_of_turn)
	battle_sim.connect("end_of_round", end_of_round)

func end_of_turn():
	bleed_damage_keeper()
	burn_damage_turn_keeper()
	poison_damage_keeper()
	stun_keeper()
	stagger_keeper()

func end_of_round(round):
	burn_damage_round_keeper()

#SKILLS=============================================================================================
func set_skills():
	skills.initialize_skills()
	
	for i in skills.enemy_skills:
		var new_instance = load(i.skill_scene_path).instantiate()
		new_instance.skill_stats = i
		new_instance.skill_stats.owner = self
		new_instance.skill_stats.target = get_tree().get_first_node_in_group("character")
		skills.add_child(new_instance)
		new_instance.upgrade_skill(new_instance.skill_stats.upgrade_level)
		
	organize_skills()

func organize_skills():
	var x_offset = 0
	for i in skills.get_children():
		i.position = Vector2(x_offset + SKILL_X_POSITION, SKILL_Y_POSITION)
		x_offset += 60

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
	enemy_deck.initialize_deck()
	deck = enemy_deck.enemy_deck

#COMBAT FUNCTIONS ==================================================================================
func take_physical_damage(damage):
	receiving_physical_dmg = damage
	receiving_physical_dmg -= character_stats.defense
	if character_stats.is_stunned: 
		receiving_physical_dmg *= 2
	if receiving_physical_dmg <= 0: receiving_physical_dmg = 0
	emit_signal("physical_damage_taken", receiving_physical_dmg)
	change_health(-receiving_physical_dmg)
	change_stagger(receiving_physical_dmg)

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

func stagger_keeper():
	if character_stats.staggered_counter >=1:
		character_stats.staggered_counter -= 1
		if character_stats.staggered_counter <= 0:
			character_stats.stagger = 0
			character_stats.can_gain_stagger = true
			change_stagger(0)

func heal_function(amount):
	emit_signal("heal_received")
	change_health(amount)

func lifesteal(damage):
	heal_function(damage)

func change_health(amount):
	character_stats.health += amount
	if character_stats.health > character_stats.max_health: character_stats.health = character_stats.max_health
	enemy_health_bar.value = character_stats.health
	enemy_health_label.text = str(int(enemy_health_bar.value)) + "/" + str(int(enemy_health_bar.max_value))
	emit_signal("health_changed")

func change_stagger(amount):
	if !character_stats.can_gain_stagger: return
	character_stats.stagger += amount
	if character_stats.stagger >= character_stats.max_stagger: 
		emit_signal("staggered")
		if !character_stats.can_be_staggered:
			return
		character_stats.staggered_counter = 2
		character_stats.can_gain_stagger = false
		on_stun(2)
	enemy_stagger_bar.value = character_stats.stagger
	enemy_stagger_label.text = str(int(enemy_stagger_bar.value)) + "/" + str(int(enemy_stagger_bar.max_value))
	emit_signal("stagger_changed")

func on_stun(turns):
	character_stats.stun_counter = turns
	stun_toggle(true)

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
	emit_signal("attack_changed")
	attack_label.text = "Atk: " + str(character_stats.attack) 

func change_defense(amount):
	character_stats.defense += amount
	emit_signal("defense_changed")
	defense_label.text = str(character_stats.defense)

func change_speed(amount):
	character_stats.speed += amount
	speed_label.text = str(character_stats.speed)

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
	reward_array = enemy_deck.enemy_deck + skills.enemy_skills 
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
	enemy_stagger_bar = get_node('%EnemyStaggerBar')
	enemy_stagger_label = get_node('%EnemyStaggerLabel')
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
	speed_label = get_node('%SpeedLabel')
	speed_panel = get_node('%SpeedPanel')
	stun_indicator = get_node('%StunIndicator')
	stun_label = get_node('%StunLabel')
	tooltip_layer = get_node('%TooltipLayer')
	tooltip = tooltip_layer.get_child(0)
	tooltip_container = tooltip.get_child(0)
	
	enemy_image.texture = load(character_stats.enemy_art_path)
	enemy_border.texture = load(character_stats.enemy_border_art_path)
	z_index = 1
	
#Runes======================================================================================
func set_runes():
	for i in character_stats.runes:
		var temp = load(i.rune_scene_path).instantiate().duplicate()
		temp.rune_stats = i
		runes.add_child(temp)
	organize_runes()

func add_rune(rune):
	character_stats.runes.push_back(rune)
	set_runes()

func organize_runes():
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


#WIP TOOLTIPS======================================================================================
func toggle_tooltip_show(location):
	if tooltip_container.get_children() == []: return
	var mouse_pos = get_viewport().get_mouse_position()
	var correction = true
	var x_offset = (%EnemyUI.size.x /2) + 20
	var y_offset = -(%EnemyUI.size.y /2) + 11
	enemy_image.scale = Vector2(1.25, 1.25)
	enemy_border.scale = Vector2(1.25, 1.25)
	tooltip.size = tooltip_container.size
	tooltip.visible = true
	tooltip_layer.visible = true
	
	#Toggles when mouse is on LEFT side of screen
	if mouse_pos.x <= get_viewport_rect().size.x/2: correction = false
	
	if correction == false:
		tooltip.position = Vector2(x_offset, y_offset) + location
	else:
		tooltip.position = Vector2(-x_offset - tooltip.size.x, y_offset) + location

func toggle_tooltip_hide():
	tooltip.visible = false
	tooltip_layer.visible = false
	enemy_image.scale = Vector2(1, 1)
	enemy_border.scale = Vector2(1, 1)

func update_tooltip(category, identifier, body = null, header = null):
	var temp
	for i in tooltip_container.get_children():
		if i.name == category: 
			temp = i
	if temp == null:
		var new_tooltip = load("res://Scenes/UI/Tooltips/tooltip_bg.tscn").instantiate()
		tooltip_container.add_child(new_tooltip)
		new_tooltip.create_tooltip(category, identifier, body, header)
	else:
		temp.update_tooltip(category, identifier, body, header)

func highlight_card(being_dragged):
	if being_dragged:
		z_index = 2
		$GlowEffect.visible = false
	else:
		z_index = 1
		$GlowEffect.visible = true
