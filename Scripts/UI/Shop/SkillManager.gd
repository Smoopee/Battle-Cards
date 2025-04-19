extends Node2D

const COLLISION_MASK_SKILL = 256
const COLLISION_MASK_MERCHANT_SKILL = 512
const COLLISION_MASK_PLAYER = 8

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
	$"../MerchantSkills".animate_skill_to_position(skill_being_dragged, skill_previous_position)
	if raycast_check_for_player(): 
		var upgradeable_skill = check_for_upgrade_skill()
		if upgradeable_skill:
			upgrade_skill(upgradeable_skill)
		else:
			buy_skill()
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

func raycast_check_for_player():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_PLAYER
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null 

func update_player_gold():
	$"../BottomNavBar".change_player_gold() 

func skill_reset():
	skill_being_dragged.scale = Vector2(1, 1)
	skill_being_dragged.z_index = 1
	skill_being_dragged = null

func check_for_upgrade_skill():
	if skill_being_dragged.skill_stats.upgrade_level >= 4: return
	for i in $"../Player/Berserker/Skills".get_children():
		if i.skill_stats.skill_name != skill_being_dragged.skill_stats.skill_name:
			continue
		if i.skill_stats.upgrade_level == skill_being_dragged.skill_stats.upgrade_level:
			return i
	return false

func upgrade_skill(skill_being_upgraded):
	if Global.player_gold < skill_being_dragged.skill_stats.buy_price:
		print("not enough gold")
		return
	$"../MerchantSkills".remove_skill_from_inventory(skill_being_dragged)
	skill_being_dragged.queue_free()
	skill_being_upgraded.upgrade_skill(skill_being_upgraded.skill_stats.upgrade_level + 1)

func buy_skill():
	if Global.player_gold < skill_being_dragged.skill_stats.buy_price:
		print("not enough gold")
		return
	Global.player_gold -= skill_being_dragged.skill_stats.buy_price
	Global.player_skills.push_back(skill_being_dragged.skill_stats)
	$"../Player/Berserker".add_skill(skill_being_dragged.skill_stats)
	$"../MerchantSkills".remove_skill_from_inventory(skill_being_dragged)
	skill_being_dragged.queue_free()
	update_player_gold()


