extends Node2D


func consumable_effect(enemy):
	print("In grenade consumable")
	if Global.current_scene != "battle_sim": return false
	get_tree().get_first_node_in_group("battle sim").physical_damage_other(self, enemy, 50, null)
	return true
