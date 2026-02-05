extends Node2D

var card_levels = []
var skill_levels = []


func reward_selection():
	card_levels = [2,5,8,11,14]
	skill_levels = [3,6,9,12,15]
	
	if card_levels.find(Global.player_level) > -1:
		load_card_rewards()
	
	if skill_levels.find(Global.player_level) > -1:
		load_skill_rewards()

func load_card_rewards():
	var creator = $"../CardSelectionCreator"
	
	creator.visible = true
	creator.process_mode = Node.PROCESS_MODE_INHERIT
	
	creator.get_inventory()
	creator.create_card_selection()
	get_tree().get_first_node_in_group("character ui").toggle_inventory(true)

func load_skill_rewards():
	var creator = $"../SkillSelectionCreator"
	var manager = $"../SkillSelectionManager"
	
	creator.visible = true
	manager.visible = true
	creator.process_mode = Node.PROCESS_MODE_INHERIT
	manager.process_mode = Node.PROCESS_MODE_INHERIT
	
	creator.get_inventory()
	creator.create_skill_selection()
	get_tree().get_first_node_in_group("character ui").toggle_inventory(false)
