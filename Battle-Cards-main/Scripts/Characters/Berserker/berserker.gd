extends Node2D

signal rage_attack_gained
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



var character_stats
var battle_sim
var deck

#COMBAT VARIABLES==================================================================================
var receiving_physical_dmg = 0
var dealing_physical_dmg = 0
var temp_physical_damage = 0

#Berserker Mechanics==============================================================================
var rage_degeneration = -3
var rage_attack_increase = 5
var additional_rage_generation = 0

func _ready():
	battle_sim = get_tree().get_first_node_in_group("battle sim")
	set_stats()
	set_talents()
	set_stat_container()
	
	$RageBar.position = get_parent().position + Vector2(70, -38)
	$PlayerHealthBar.max_value = character_stats.max_health
	$PlayerHealthBar.value = character_stats.health
	$PlayerHealthBar/PlayerHealthLabel.text = str(int($PlayerHealthBar.value)) + "/" + str(int($PlayerHealthBar.max_value))

#SETUP  ===========================================================================================
func set_stats() -> void:
	character_stats = Global.player_stats
	
	#RESETS COMBAT STATS
	character_stats.bleeding_dmg = 0
	character_stats.burning_dmg = 0
	character_stats.poisoning_dmg = 0
	character_stats.attack = 0
	character_stats.armor = 0
	character_stats.defense = 0
	character_stats.block = 0
	character_stats.stun_counter = 0
	character_stats.is_stunned = false

func set_stat_container():
	$StatContainer/Panel/HBoxContainer/AttackLabel.text = str(character_stats.attack)
	$StatContainer/Panel2/HBoxContainer/DefenseLabel.text =  str(character_stats.defense)
	$StatContainer/Panel3/HBoxContainer/ArmorLabel.text =  str(character_stats.armor)

func set_talents():
	for i in Global.player_talent_array:
		if i == null: continue
		var new_talent = load(i).instantiate()
		$Talents.add_child(new_talent)
		new_talent.set_talent()

#SIGNALS ===========================================================================================
func connect_signals(battle_sim):
	battle_sim.connect("end_of_turn", end_of_turn)

func end_of_turn():
	change_rage(rage_degeneration)
	bleed_damage_keeper()
	burn_damage_turn_keeper()
	poison_damage_keeper()
	stun_keeper()

func end_of_round():
	burn_damage_round_keeper()

#BUFFS/DEBUFFS =====================================================================================
func add_buff(buff_resource, source):
	get_tree().get_first_node_in_group("player buffs").add_buff(buff_resource, source)

func remove_buff(buff):
	get_tree().get_first_node_in_group("player buffs").remove_buff(buff)

func buff_reset():
	get_tree().get_first_node_in_group("player buffs").buff_reset()

func add_debuff(debuff_resource, source):
	get_tree().get_first_node_in_group("player debuffs").add_debuff(debuff_resource, source)

func remove_debuff(debuff):
	get_tree().get_first_node_in_group("player debuffs").remove_debuff(debuff)

func debuff_reset():
	get_tree().get_first_node_in_group("player debuffs").debuff_reset()


#COMBAT FUNCTIONS ==================================================================================
func take_physical_damage(damage):
	receiving_physical_dmg = damage
	receiving_physical_dmg -= character_stats.armor
	receiving_physical_dmg -= character_stats.defense
	receiving_physical_dmg = block_damage(damage)
	if character_stats.is_stunned: 
		receiving_physical_dmg *= 2
	if receiving_physical_dmg <= 0: receiving_physical_dmg = 0
	emit_signal("physical_damage_taken", receiving_physical_dmg)
	change_health(-receiving_physical_dmg)
	change_rage(receiving_physical_dmg)

func deal_physical_damage(damage):
	dealing_physical_dmg = damage
	dealing_physical_dmg += character_stats.attack + temp_physical_damage
	emit_signal("physical_damage_dealt", dealing_physical_dmg)
	change_rage(dealing_physical_dmg + additional_rage_generation)
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
		$StunIndicator/Label.text = str(character_stats.stun_counter)
	
	if character_stats.stun_counter <= 0:
		stun_toggle(false)

func heal(amount):
	emit_signal("heal_received", amount)
	change_health(amount)

func lifesteal(damage):
	heal(damage)

func change_health(amount):
	character_stats.health += amount
	if character_stats.health > character_stats.max_health: character_stats.health = character_stats.max_health
	$PlayerHealthBar.value = character_stats.health
	$PlayerHealthBar/PlayerHealthLabel.text = str(int($PlayerHealthBar.value)) + "/" + str(int($PlayerHealthBar.max_value))
	emit_signal("health_changed")

func stun_toggle(toggle):
	if toggle: 
		$StunIndicator.visible = true
		character_stats.is_stunned = true
		$StunIndicator/Label.text = str(character_stats.stun_counter)
	else: 
		$StunIndicator.visible = false
		character_stats.is_stunned = false

#UI CHANGES ========================================================================================
func change_rage(value):
	var rage_bar = $RageBar
	rage_bar.value += value
	if  rage_bar.value  >= 100:
		rage_bar.value = 0
		rage_bar.max_value += 10
		rage_attack_buff()

func change_attack(amount):
	character_stats.attack += amount
	$StatContainer/Panel/HBoxContainer/AttackLabel.text = str(character_stats.attack) 

func change_defense(amount):
	character_stats.defense += amount
	$StatContainer/Panel2/HBoxContainer/DefenseLabel.text = str(character_stats.defense)

func change_armor(amount):
	character_stats.armor += amount
	$StatContainer/Panel3/HBoxContainer/ArmorLabel.text = str(character_stats.armor)

func change_block():
	$BlockSymbol.visible = true
	$BlockSymbol/Label.text = str(character_stats.block)
	if character_stats.block <= 0: $BlockSymbol.visible = false

#CLASS MECHANICS ==============================================+====================================
func block_damage(damage):
	var mitigated_damage
	mitigated_damage = damage - character_stats.block
	if mitigated_damage < 0: mitigated_damage = 0
	character_stats.block = 0 
	change_block()
	return mitigated_damage

func rage_attack_buff():
	var buff_resource = load("res://Resources/Buffs/raging.tres")
	add_buff(buff_resource, self)

#OTHER =============================================================================================
func active_deck_access():
	var temp_array = Global.player_deck + Global.player_inventory
	return temp_array
