extends Node2D

const COLLISION_MASK_SKILL = 256
const COLLISION_MASK_MERCHANT_SKILL = 512
const COLLISION_MASK_SKILL_DROP_OFF = 8

var screen_size

var skill_previous_position
var skill_being_dragged

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	if skill_being_dragged:
		var mouse_pos = get_global_mouse_position()
		skill_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), 
			clamp(mouse_pos.y, 0, screen_size.y))

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var merchant_skill = raycast_check_for_skill()
			if merchant_skill:
				start_drag_skill(merchant_skill)
		else:
			if skill_being_dragged:
				finish_drag_skill()

func finish_drag_skill():
	$"../SkillSelectionCreator".animate_skill_to_position(skill_being_dragged, skill_previous_position)
	if raycast_check_for_skill_drop_off(): 
		var upgradeable_skill = check_for_upgrade_skill()
		if upgradeable_skill:
			upgrade_skill(upgradeable_skill)
		else:
			get_skill()
	skill_reset()

func start_drag_skill(skill):
	skill_being_dragged = skill
	skill_being_dragged.scale = Vector2(1.1, 1.1)
	skill_being_dragged.z_index = 2
	skill_previous_position = skill.position

func raycast_check_for_skill():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_MERCHANT_SKILL
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null 

func raycast_check_for_skill_drop_off():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_SKILL_DROP_OFF
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null 

func update_player_gold():
	get_tree().get_first_node_in_group("bottom ui").change_player_gold() 

func skill_reset():
	skill_being_dragged.scale = Vector2(1, 1)
	skill_being_dragged.z_index = 1
	skill_being_dragged = null

func check_for_upgrade_skill():
	if skill_being_dragged.skill_stats.upgrade_level >= 4: return
	for i in get_tree().get_first_node_in_group("player skills").get_children():
		if i.skill_stats.skill_name != skill_being_dragged.skill_stats.skill_name:
			continue
		if i.skill_stats.upgrade_level == skill_being_dragged.skill_stats.upgrade_level:
			return i
	return false

func upgrade_skill(skill_being_upgraded):
	$"../SkillSelectionCreator".remove_skill_from_inventory(skill_being_dragged)
	skill_being_dragged.queue_free()
	skill_being_upgraded.upgrade_skill(skill_being_upgraded.skill_stats.upgrade_level + 1)

func get_skill():
	Global.player_skills.push_back(skill_being_dragged.skill_stats)
	get_tree().get_first_node_in_group("player skills").add_skill(skill_being_dragged.skill_stats)
	$"../SkillSelectionCreator".remove_skill_from_inventory(skill_being_dragged)
	skill_being_dragged.queue_free()
	update_player_gold()


