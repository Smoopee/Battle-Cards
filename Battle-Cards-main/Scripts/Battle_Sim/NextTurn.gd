extends Node2D

func initial_build():
	get_tree().get_first_node_in_group("enemy deck").build_deck()

func next_turn():
	cd_handler(get_tree().get_nodes_in_group("card"))
	get_tree().get_first_node_in_group("enemy deck").build_deck()
	slot_player_cards()
	get_tree().get_first_node_in_group("character ui").toggle_inventory(true)
	$"..".start_pre_battle_animation()
	$"../InterruptUI".visible = true
	$"../InterruptUI".interrupt_reset()
	get_tree().get_first_node_in_group("active spots").apply_active_effects()

func cd_handler(cards):
	for i in cards:
		if i == null: continue
		i.card_stats.cd_remaining -= 1
		if i.card_stats.cd_remaining <= 0: i.card_stats.on_cd = false
		i.get_node("BaseCard").update_card_ui()

func slot_player_cards():
	get_tree().get_first_node_in_group("player cards").process_mode = Node.PROCESS_MODE_INHERIT
	for i in get_tree().get_nodes_in_group("card"):
		if i.card_stats.name == "Blank" : i.queue_free()
		if i.card_stats.owner == get_tree().get_nodes_in_group("character")[0]:
			i.scale = Vector2(1, 1)
			i.get_node("BaseCard").enable_collision()
			
			i.z_index = 1
	
	var count = 0
	for i in get_tree().get_first_node_in_group("player cards").deck_card_slot_reference:
		if i == null:
			count += 1
			continue
		i.position = get_tree().get_first_node_in_group("player cards").deck_card_slot_array[count].position
		count += 1
	
	count = 0
	for i in get_tree().get_first_node_in_group("player cards").inventory_card_slot_reference:
		if i == null:
			count += 1
			continue
		i.position = get_tree().get_first_node_in_group("player cards").inventory_card_slot_array[count].position
		i.visible = true
		count += 1

func end_fight():
	get_tree().get_first_node_in_group("enemy deck").build_deck()
	#$"../ConsumableManger".visible = false
	
	for i in get_tree().get_nodes_in_group("card"):
		i.get_node("BaseCard").card_reset()
