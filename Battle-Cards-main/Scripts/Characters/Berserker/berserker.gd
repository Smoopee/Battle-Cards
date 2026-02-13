extends Node2D


signal health_changed
signal stagger_changed
signal attack_changed
signal defense_changed
signal staggered
signal stunned
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
var additional_rage_generation = 0


func _ready():
	battle_sim = get_tree().get_first_node_in_group("battle sim")
	set_stats()
	set_talents()
	set_health()
	set_rage()
	set_stagger()

#SETUP  ===========================================================================================
func set_stats() -> void:
	character_stats = Global.player_stats
	
	#RESETS COMBAT STATS
	character_stats.bleeding_dmg = 0
	character_stats.burning_dmg = 0
	character_stats.poisoning_dmg = 0
	character_stats.attack = 0
	character_stats.defense = 0
	character_stats.stagger = 0
	character_stats.rage = 0
	character_stats.block = 0
	character_stats.stun_counter = 0
	character_stats.is_stunned = false
	set_stat_container()

func set_stat_container():
	$StatContainer/Panel/HBoxContainer/AttackLabel.text = str(character_stats.attack)
	$StatContainer/Panel2/HBoxContainer/DefenseLabel.text =  str(character_stats.defense)
	$StatContainer/Panel3/HBoxContainer/SpeedLabel.text = str(character_stats.speed)

func set_talents():
	for i in Global.player_talent_array:
		if i == null: continue
		var new_talent = load(i).instantiate()
		$Talents.add_child(new_talent)
		#new_talent.set_talent()

func set_stagger():
	$PlayerStaggerBar.max_value = character_stats.max_stagger
	$PlayerStaggerBar.value = character_stats.stagger
	$PlayerStaggerBar/PlayerStaggerLabel.text = str(int($PlayerStaggerBar.value)) + "/" + str(int($PlayerStaggerBar.max_value))

func set_rage():
	$RageBar.max_value = character_stats.max_rage
	$RageBar.value = character_stats.rage
	$RageBar/RageLabel.text = str(int($RageBar.value)) + "/" + str(int($RageBar.max_value))

func set_health():
	$PlayerHealthBar.max_value = character_stats.max_health
	$PlayerHealthBar.value = character_stats.health
	$PlayerHealthBar/PlayerHealthLabel.text = str(int($PlayerHealthBar.value)) + "/" + str(int($PlayerHealthBar.max_value))


func end_fight_reset():
	buff_reset()
	debuff_reset()
	set_stats()
	set_stagger()
	set_rage()
	change_block()


#SIGNALS ===========================================================================================
func connect_signals(battle_sim):
	battle_sim.connect("end_of_turn", end_of_turn)

func end_of_turn():
	change_rage(rage_degeneration)
	bleed_damage_keeper()
	burn_damage_turn_keeper()
	poison_damage_keeper()
	stagger_keeper()
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
	receiving_physical_dmg -= character_stats.defense
	receiving_physical_dmg = block_damage(damage)
	if character_stats.is_stunned: 
		receiving_physical_dmg *= 2
	if receiving_physical_dmg <= 0: receiving_physical_dmg = 0
	emit_signal("physical_damage_taken", receiving_physical_dmg)
	change_health(-receiving_physical_dmg)
	change_stagger(receiving_physical_dmg)
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

func stagger_keeper():
	if character_stats.staggered_counter >=1:
		character_stats.staggered_counter -= 1
		if character_stats.staggered_counter <= 0:
			character_stats.stagger = 0
			character_stats.can_gain_stagger = true
			change_stagger(0)
 

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
	$PlayerStaggerBar.value = character_stats.stagger
	$PlayerStaggerBar/PlayerStaggerLabel.text = str(int($PlayerStaggerBar.value)) + "/" + str(int($PlayerStaggerBar.max_value))
	emit_signal("stagger_changed")

func on_stun(turns):
	character_stats.stun_counter = turns
	stun_toggle(true)

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
	var rage_label = $RageBar/RageLabel
	character_stats.rage += value
	if character_stats.rage >= character_stats.max_rage:
		character_stats.rage = character_stats.max_rage
	rage_bar.value = character_stats.rage
	rage_label.text = str(int(rage_bar.value))

func change_attack(amount):
	character_stats.attack += amount
	emit_signal("attack_changed")
	$StatContainer/Panel/HBoxContainer/AttackLabel.text = str(character_stats.attack) 

func change_defense(amount):
	character_stats.defense += amount
	emit_signal("defense_changed")
	$StatContainer/Panel2/HBoxContainer/DefenseLabel.text = str(character_stats.defense)

func change_speed(amount):
	character_stats.speed += amount
	$StatContainer/Panel3/HBoxContainer/SpeedLabel.text = str(character_stats.speed)

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


#OTHER =============================================================================================
func active_deck_access():
	var temp_array = Global.player_deck + Global.player_inventory
	return temp_array
