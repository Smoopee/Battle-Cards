extends Node2D

signal rage_attack_gained

const BUFF_X_POSITION = 675
const BUFF_Y_POSITION = -100
const SKILL_X_POSITION = 600
const SKILL_Y_POSITION = -40
const CONSUMABLE_X_POSITION = -100
const CONSUMABLE_Y_POSITION = -60
const CONSUMABLE_Y_HORIZONTAL_POSITION = 950

@export var character_stats_resource: Character_Resource

var character_stats: Character_Resource = null
var battle_sim
var deck
var consumable_orientation = true

#Berserker Mechanics==============================================================================
var rage_degeneration = -3
var rage_attack_increase = 5
var additional_rage_generation = 0

func _ready():
	battle_sim = get_tree().get_first_node_in_group("battle sim")
	set_stats(character_stats_resource)
	set_talents()
	set_skills()
	set_consumables()
	set_stat_container()
	
	$RageBar.position = get_parent().position + Vector2(70, -38)
	$PlayerHealthBar.max_value = Global.max_player_health
	$PlayerHealthBar.value = Global.player_health
	$PlayerHealthBar/PlayerHealthLabel.text = str($PlayerHealthBar.value) + "/" + str($PlayerHealthBar.max_value)

func set_stats(stats = Character_Resource) -> void:
	character_stats = load("res://Resources/Character/berserker.tres").duplicate()

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

func set_skills():
	var player_skills = Global.player_skills

	for i in player_skills:
		var new_instance = load(i.skill_scene_path).instantiate()
		new_instance.skill_stats = i
		new_instance.attached_to = self
		new_instance.upgrade_skill(new_instance.skill_stats.upgrade_level)
		$Skills.add_child(new_instance)
	
	organize_skills()

func add_skill(skill):
	var new_instance = load(skill.skill_scene_path).instantiate()
	new_instance.skill_stats = skill
	new_instance.attached_to = self
	new_instance.upgrade_skill(new_instance.skill_stats.upgrade_level)
	$Skills.add_child(new_instance)
	organize_skills()

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

func change_player_health():
	$PlayerHealthBar.value = Global.player_health
	$PlayerHealthBar/PlayerHealthLabel.text = str($PlayerHealthBar.value) + "/" + str($PlayerHealthBar.max_value)

func change_rage(source, value):
	var rage_bar = $RageBar
	rage_bar.value += value
	if  rage_bar.value  >= 100:
		change_attack(rage_attack_increase)
		rage_bar.value = 0
		rage_bar.max_value += 10
		rage_attack_buff()

func rage_attack_buff():
	for i in get_tree().get_nodes_in_group("buff"):
		if i.buff_name == "Rage Attack Increase" and i.attached_to == self: 
			i.increase_buff(self)
			return
			
	var new_buff = load("res://Scenes/Buffs/rage_attack_increase_buff.tscn").instantiate()
	add_buff(new_buff, self)

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

func organize_skills():
	var x_offset = 0
	for i in $Skills.get_children():
		i.position = Vector2(x_offset + SKILL_X_POSITION, SKILL_Y_POSITION)
		x_offset += 60

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

func connect_signals(battle_sim):
	battle_sim.connect("physical_damage", physical_damage_taken)
	battle_sim.connect("physical_damage", physical_damage_dealt)
	battle_sim.connect("end_of_turn", end_of_turn)

func physical_damage_taken(source, target, damage, card):
	if source == self: return
	change_rage(source, battle_sim.damage + additional_rage_generation)
	block_damage()

func physical_damage_dealt(source, target, damage, card):
	if source != self: return
	change_rage(source, battle_sim.damage + additional_rage_generation)

func end_of_turn():
	change_rage(self, rage_degeneration)

func block_damage():
	var mitigated_damage
	mitigated_damage = battle_sim.damage - character_stats.block
	if mitigated_damage < 0: mitigated_damage = 0
	
	battle_sim.damage = mitigated_damage
	character_stats.block = 0 
	change_block()

func _on_buff_container_child_order_changed():
	if get_node_or_null("BuffContainer") == null: return
	organize_buffs()

func inventory_screen_toggle(toggle):
	if toggle:
		$RageBar.visible = false
		$StatContainer.visible = false
		$BlockSymbol.visible = false
		$ClassImage.visible = false
		$Skills.visible = false
		$PlayerHealthBar.visible = false
		$Area2D.process_mode = Node.PROCESS_MODE_DISABLED
		organize_consumables_horiziontal()
	if !toggle:
		$RageBar.visible = true
		$StatContainer.visible = true
		if character_stats.block >= 0: $BlockSymbol.visible = true
		$ClassImage.visible = true
		$Skills.visible = true
		$PlayerHealthBar.visible = true
		$Area2D.process_mode = Node.PROCESS_MODE_INHERIT
		organize_consumables()

func active_deck_access():
	var temp_array = Global.player_active_deck + Global.player_active_inventory
	return temp_array

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
