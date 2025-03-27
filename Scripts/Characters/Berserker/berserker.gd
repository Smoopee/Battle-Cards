extends Node2D


const BUFF_X_POSITION = 675
const BUFF_Y_POSITION = -100

@export var character_stats_resource: Character_Resource

var player_stats: Character_Resource = null
var battle_sim

var spiked_armor = false

#Berserker Mechanics==============================================================================
var rage_degeneration = -3
var rage_attack_increase = 5

func _ready():
	battle_sim = get_tree().get_first_node_in_group("battle sim")
	set_stats(character_stats_resource)
	set_talents()
	set_stat_container()
	
	$RageBar.position = get_parent().position + Vector2(70, -38)
	$PlayerHealthBar.max_value = Global.max_player_health
	$PlayerHealthBar.value = Global.player_health
	$PlayerHealthBar/PlayerHealthLabel.text = str($PlayerHealthBar.value) + "/" + str($PlayerHealthBar.max_value)


func set_stats(stats = Character_Resource) -> void:
	player_stats = load("res://Resources/Character/berserker.tres").duplicate()

func set_stat_container():
	$StatContainer/Panel/HBoxContainer/AttackLabel.text = str(player_stats.attack)
	$StatContainer/Panel2/HBoxContainer/DefenseLabel.text =  str(player_stats.defense)
	$StatContainer/Panel3/HBoxContainer/ArmorLabel.text =  str(player_stats.armor)

func set_talents():
	for i in Global.player_talent_array:
		if i == null: continue
		var new_talent = load(i).instantiate()
		$Talents.add_child(new_talent)
		new_talent.set_talent()

func change_player_health():
	$PlayerHealthBar.value = Global.player_health
	$PlayerHealthBar/PlayerHealthLabel.text = str($PlayerHealthBar.value) + "/" + str($PlayerHealthBar.max_value)

func change_rage(source, value):
	var rage_bar = $RageBar
	rage_bar.value += value
	if  rage_bar.value  >= 100:
		player_stats.attack += rage_attack_increase
		change_attack_label()
		rage_bar.value = 0
		rage_bar.max_value += 10

func change_attack_label():
	$StatContainer/Panel/HBoxContainer/AttackLabel.text = str(player_stats.attack) 

func change_defense_label():
	$StatContainer/Panel2/HBoxContainer/DefenseLabel.text = str(player_stats.defense)

func change_armor_label():
	$StatContainer/Panel3/HBoxContainer/ArmorLabel.text = str(player_stats.armor)

func change_block():
	$BlockSymbol.visible = true
	$BlockSymbol/Label.text = str(player_stats.block)
	if player_stats.block <= 0: $BlockSymbol.visible = false

func add_buff(buff, source):
	$BuffContainer.add_child(buff)
	buff.buff_initializer(source, self)
	organize_buffs()

func remove_buff(buff):
	for i in $BuffContainer.get_children():
		print(i.buff_name)
		print(buff)
		if i.buff_name == buff:
			i.queue_free()
	organize_buffs()

func organize_buffs():
	var x_offset = 0
	for i in $BuffContainer.get_children():
		i.position = $BuffContainer.position + Vector2(x_offset + BUFF_X_POSITION, BUFF_Y_POSITION)
		i.scale = Vector2(2,2)
		x_offset += 50

func connect_signals(battle_sim):
	battle_sim.connect("physical_damage", physical_damage_taken)
	battle_sim.connect("physical_damage", physical_damage_dealt)
	battle_sim.connect("end_of_turn", end_of_turn)

func physical_damage_taken(damage, source):
	if source == self: return
	change_rage(source, damage)
	block_damage()

func physical_damage_dealt(damage, source):
	if source != self: return
	change_rage(source, damage)

func end_of_turn():
	change_rage(self, rage_degeneration)

func block_damage():
	var mitigated_damage
	mitigated_damage = battle_sim.damage - player_stats.block
	if mitigated_damage < 0: mitigated_damage = 0
	
	battle_sim.damage = mitigated_damage
	player_stats.block = 0 
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
	if !toggle:
		$RageBar.visible = true
		$StatContainer.visible = true
		if player_stats.block >= 0: $BlockSymbol.visible = true
		$ClassImage.visible = true
