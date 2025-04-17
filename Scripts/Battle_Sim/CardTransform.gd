extends Node

const COLLISION_MASK_CARD = 1
var transform_array = []

func add_card_transform(orignial, new):
	transform_array.push_back([orignial, new])

func revert_cards():
	for i in transform_array:
		var deck_check = revert_deck(i)
		if !deck_check: revert_inventory(i)

func revert_deck(i):
	for j in get_tree().get_first_node_in_group("card manager").deck_card_slot_reference:

		if j == null: continue
			
		if j.card_stats == i[1]:
			var index = get_tree().get_first_node_in_group("card manager").deck_card_slot_reference.find(j)
			var original_resource = i[0]
			var original_card = load(original_resource.card_scene_path).instantiate().duplicate()
			get_tree().get_first_node_in_group("player deck").add_child(original_card)
			original_card.card_stats = original_resource
			original_card.get_node("Area2D").collision_mask = COLLISION_MASK_CARD
			original_card.get_node("Area2D").collision_layer = COLLISION_MASK_CARD
			original_card.upgrade_card(original_card.card_stats.upgrade_level)
			original_card.card_stats.in_enemy_deck = false
			original_card.card_stats.card_owner = get_tree().get_first_node_in_group("character")
			original_card.card_stats.is_players = true
			original_card.position = j.position
			original_card.z_index = j.z_index
			get_tree().get_first_node_in_group("card manager").deck_card_slot_reference[index] = original_card
			j.queue_free()
			return true

func revert_inventory(i):
	for j in get_tree().get_first_node_in_group("card manager").inventory_card_slot_reference:
		
		if j == null: continue
			
		if j.card_stats == i[1]:
			var index = get_tree().get_first_node_in_group("card manager").inventory_card_slot_reference.find(j)
			var original_resource = i[0]
			var original_card = load(original_resource.card_scene_path).instantiate().duplicate()
			get_tree().get_first_node_in_group("player inventory").add_child(original_card)
			original_card.card_stats = original_resource
			original_card.get_node("Area2D").collision_mask = COLLISION_MASK_CARD
			original_card.get_node("Area2D").collision_layer = COLLISION_MASK_CARD
			original_card.upgrade_card(original_card.card_stats.upgrade_level)
			original_card.card_stats.in_enemy_deck = false
			original_card.card_stats.card_owner = get_tree().get_first_node_in_group("character")
			original_card.card_stats.is_players = true
			original_card.position = j.position
			original_card.z_index = j.z_index
			get_tree().get_first_node_in_group("card manager").inventory_card_slot_reference[index] = original_card
			j.queue_free()
			return
