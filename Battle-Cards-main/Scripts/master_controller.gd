extends Node2D

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_CARD_SELECTOR = 16
const COLLISION_MASK_MERCHANT_CARD = 64
const COLLISION_MASK_MERCHANT = 32
const COLLISION_MASK_PLAYER = 8
const COLLISION_MASK_DECK_SLOT = 2
const COLLISION_MASK_INVENTORY_SLOT = 4
const COLLISION_MASK_RUNE = 32768
const COLLISION_MASK_ENEMY = 128
const COLLISION_MASK_CONSUMABLE = 2048
const COLLISION_MASK_PLAYER_CARD = 1
const COLLISION_MASK_ENEMY_CARD = 64
const COLLISION_MASK_SKILL = 256
const COLLISION_MASK_MERCHANT_SKILL = 512
const COLLISION_MASK_MERCHANT_CONSUMABLE = 8192

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			match_raycast(get_raycast())

func get_raycast():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	#parameters.collision_mask = collision_mask
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.collision_mask
	return null 

func match_raycast(raycast_num):
	match raycast_num:
		1:
			print("Player Card")
		2:
			if Global.current_scene == "title_screen":
				print("Start Slot")
		16: 
			print("card selector")
			get_tree().get_first_node_in_group("card selector").process_mode = Node.PROCESS_MODE_INHERIT
