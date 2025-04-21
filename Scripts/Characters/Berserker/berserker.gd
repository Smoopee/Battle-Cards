extends Node2D

signal rage_attack_gained
signal health_changed

signal physical_damage_dealt
signal physical_damage_taken
signal bleeding_damage_applied
signal bleeding_damage_taken

const BUFF_X_POSITION = 675
const BUFF_Y_POSITION = -100
const SKILL_X_POSITION = 600
const SKILL_Y_POSITION = -40
const CONSUMABLE_X_POSITION = -100
const CONSUMABLE_Y_POSITION = -60
const CONSUMABLE_Y_HORIZONTAL_POSITION = 950
const RUNE_X_POSITION = -150
const RUNE_Y_POSITION = -60


var character_stats
var battle_sim
var deck
var consumable_orientation = true

#COMBAT VARIABLES==================================================================================
var temp_physical_damage = 0

#Berserker Mechanics==============================================================================
var rage_degeneration = -3
var rage_attack_increase = 5
var additional_rage_generation = 0

func _ready():
	battle_sim = get_tree().get_first_node_in_group("battle sim")
	set_stats()
	set_talents()
	set_skills()
	set_consumables()
	set_runes()
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
	stun_keeper()

#CONSUMABLES =======================================================================================
func set_consumables():
	var player_consumables = Global.player_consumables

	for i in player_consumables:
		var new_instance = load(i.consumable_scene_path).instantiate()
		new_instance.consumable_stats = i
		new_instance.update_stack_ui()
		new_instance.toggle_info_ui(true)
		$Consumables.add_child(new_instance)
	
	organize_consumables()

func add_consumable(consumable):
	for i in $Consumables.get_children():
		if i.consumable_stats.consumable_name == consumable.consumable_name:
			i.consumable_stats.stack_amount += 1
			i.update_stack_ui()
			i.toggle_info_ui(true)
			return
			
	var new_instance = load(consumable.consumable_scene_path).instantiate()
	new_instance.consumable_stats = consumable
	$Consumables.add_child(new_instance)
	organize_consumables()

func organize_consumables():
	var counter = 0
	var x_offset = 0
	var y_offset = 0
	
	for i in $Consumables.get_children():
		if counter >= 5: 
			x_offset = -32
			y_offset = 0
			counter = 0
		i.position = Vector2(x_offset + CONSUMABLE_X_POSITION, y_offset + CONSUMABLE_Y_POSITION)
		y_offset += 30
		counter += 1
	
	consumable_orientation = true

func _on_consumables_child_order_changed():
	if get_node_or_null("Consumables") == null: return
	if consumable_orientation == true: organize_consumables()
	else: organize_consumables_horiziontal()

func organize_consumables_horiziontal():
	var counter = 0
	for i in $Consumables.get_children():
		i.global_position = Vector2(calculate_consumable_horizontal_position(counter), CONSUMABLE_Y_HORIZONTAL_POSITION)
		counter += 1
	consumable_orientation = false

func calculate_consumable_horizontal_position(index):
	var center_screen_x = get_viewport().size.x / 2
	var total_width = ($Consumables.get_children().size() - 1) * 35
	var x_offset = center_screen_x + index * 35 - total_width / 2
	return x_offset

func get_consumable_array():
	var consumable_array = []
	for i in $Consumables.get_children():
		consumable_array.push_back(i.consumable_stats)
	
	return consumable_array

#SKILLS ===========================================================================================
func set_skills():
	var player_skills = Global.player_skills

	for i in player_skills:
		var new_instance = load(i.skill_scene_path).instantiate()
		new_instance.skill_stats = i
		new_instance.skill_stats.owner = self
		new_instance.skill_stats.target = get_tree().get_first_node_in_group("enemy")
		new_instance.upgrade_skill(new_instance.skill_stats.upgrade_level)
		$Skills.add_child(new_instance)
	
	organize_skills()

func add_skill(skill):
	var new_instance = load(skill.skill_scene_path).instantiate()
	new_instance.skill_stats = skill
	new_instance.skill_stats.owner = self
	print(new_instance.skill_stats.owner)
	new_instance.upgrade_skill(new_instance.skill_stats.upgrade_level)
	$Skills.add_child(new_instance)
	organize_skills()

func organize_skills():
	var x_offset = 0
	for i in $Skills.get_children():
		i.position = Vector2(x_offset + SKILL_X_POSITION, SKILL_Y_POSITION)
		x_offset += 60

#RUNES =============================================================================================
func set_runes():
	var player_runes = Global.player_runes

	for i in player_runes:
		var new_instance = load(i.rune_scene_path).instantiate()
		new_instance.rune_stats = i
		$Runes.add_child(new_instance)
	
	organize_runes()

func add_rune(rune):
	var new_instance = load(rune.rune_scene_path).instantiate()
	new_instance.rune_stats = rune
	$Runes.add_child(new_instance)
	organize_runes()

func organize_runes():
	var counter = 0
	var x_offset = 0
	var y_offset = 0
	
	for i in $Runes.get_children():
		if counter >= 5: 
			x_offset = -32
			y_offset = 0
			counter = 0
		i.position = Vector2(x_offset + RUNE_X_POSITION, y_offset + RUNE_Y_POSITION)
		y_offset += 30
		counter += 1

func get_rune_array():
	var rune_array = []
	for i in $Runes.get_children():
		rune_array.push_back(i.rune_stats)
	
	return rune_array

#BUFFS ============================================================================================
func add_buff(buff, source):
	$BuffContainer.add_child(buff)
	buff.buff_initializer(source, self)
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
		i.scale = Vector2(2,2)
		x_offset += 50

func _on_buff_container_child_order_changed():
	if get_node_or_null("BuffContainer") == null: return
	organize_buffs()

#COMBAT FUNCTIONS ==================================================================================
func take_physical_damage(damage):
	damage -= character_stats.armor
	damage -= character_stats.defense
	if character_stats.is_stunned: 
		damage *= 2
	emit_signal("physical_damage_taken", damage)
	change_health(-damage)
	change_rage(damage)

func deal_physical_damage(damage):
	damage += character_stats.attack + temp_physical_damage
	emit_signal("physical_damage_dealt", damage)
	change_rage(damage + additional_rage_generation)
	temp_physical_damage = 0
	return damage

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

func stun_keeper():
	if character_stats.stun_counter >= 1:
		character_stats.stun_counter -= 1
		$StunIndicator/Label.text = str(character_stats.stun_counter)
	
	if character_stats.stun_counter <= 0:
		stun_toggle(false)

func change_health(amount):
	character_stats.health += amount
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
		$Runes.visible = false
		$Skills.visible = false
		$PlayerHealthBar.visible = false
		$Area2D.process_mode = Node.PROCESS_MODE_DISABLED
		organize_consumables_horiziontal()
	if !toggle:
		$RageBar.visible = true
		$StatContainer.visible = true
		if character_stats.block >= 0: $BlockSymbol.visible = true
		$ClassImage.visible = true
		$Runes.visible = true
		$Skills.visible = true
		$PlayerHealthBar.visible = true
		$Area2D.process_mode = Node.PROCESS_MODE_INHERIT
		organize_consumables()

func active_deck_access():
	var temp_array = Global.player_active_deck + Global.player_active_inventory
	return temp_array
