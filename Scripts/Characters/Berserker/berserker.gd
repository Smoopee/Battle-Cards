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

const BUFF_X_POSITION = 675
const BUFF_Y_POSITION = -100


var character_stats
var battle_sim
var deck
var consumable_orientation = true

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
	$PlayerHealthBar/PlayerHealthLabel.text = str($PlayerHealthBar.value) + "/" + str($PlayerHealthBar.max_value)

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


#BUFFS ============================================================================================
func add_buff(buff, source):
	$BuffContainer.add_child(buff)
	buff.buff_initializer(source)
	organize_buffs()

func remove_buff(buff):
	for i in $BuffContainer.get_children():
		if i.buff_name == buff:
			i.queue_free()
	organize_buffs()

func organize_buffs():
	var x_offset = 0
	for i in $BuffContainer.get_children():
		i.position = $BuffContainer.position + Vector2(x_offset + BUFF_X_POSITION, BUFF_Y_POSITION)
		i.scale = Vector2(1,1)
		x_offset += 50

func _on_buff_container_child_order_changed():
	if get_node_or_null("BuffContainer") == null: return
	organize_buffs()

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
	$PlayerHealthBar/PlayerHealthLabel.text = str($PlayerHealthBar.value) + "/" + str($PlayerHealthBar.max_value)
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
		change_attack(rage_attack_increase)
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
func block_damage():
	var mitigated_damage
	mitigated_damage = battle_sim.damage - character_stats.block
	if mitigated_damage < 0: mitigated_damage = 0
	
	battle_sim.damage = mitigated_damage
	character_stats.block = 0 
	change_block()

func rage_attack_buff():
	for i in get_tree().get_nodes_in_group("buff"):
		if i.buff_name == "Rage Attack Increase" and i.attached_to == self: 
			i.increase_buff(self)
			return
			
	var new_buff = load("res://Scenes/Buffs/rage_attack_increase_buff.tscn").instantiate()
	add_buff(new_buff, self)

#OTHER =============================================================================================
func inventory_screen_toggle(toggle):
	if toggle:
		$RageBar.visible = false
		$StatContainer.visible = false
		$BlockSymbol.visible = false
		$ClassImage.visible = false
		get_tree().get_first_node_in_group("player runes").visible = false
		get_tree().get_first_node_in_group("player skills").visible = false
		$PlayerHealthBar.visible = false
		$Area2D.process_mode = Node.PROCESS_MODE_DISABLED
		get_tree().get_first_node_in_group("player consumables").organize_consumables_horiziontal()
	if !toggle:
		$RageBar.visible = true
		$StatContainer.visible = true
		if character_stats.block >= 0: $BlockSymbol.visible = true
		$ClassImage.visible = true
		get_tree().get_first_node_in_group("player runes").visible = true
		get_tree().get_first_node_in_group("player skills").visible = true
		$PlayerHealthBar.visible = true
		$Area2D.process_mode = Node.PROCESS_MODE_INHERIT
		get_tree().get_first_node_in_group("player consumables").organize_consumables()

func active_deck_access():
	var temp_array = Global.player_deck + Global.player_inventory
	return temp_array
