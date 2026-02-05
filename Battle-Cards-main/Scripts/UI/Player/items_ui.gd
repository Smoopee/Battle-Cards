extends Panel

@onready var player_consumables = $"../PlayerConsumables"
@onready var player_runes = $"../PlayerRunes"



func hide_inventory():
	player_consumables.visible = false
	player_runes.visible = false
	get_tree().get_first_node_in_group("character ui").toggle_inventory(false)


func toggle_consumables(toggle):
	if toggle:
		player_consumables.visible = true
		player_runes.visible = false
	else: hide_inventory()

func toggle_runes(toggle):
	if toggle:
		player_consumables.visible = false
		player_runes.visible = true
	else: hide_inventory()

func toggle_side_deck(toggle):
	if toggle:
		get_tree().get_first_node_in_group("character ui").toggle_inventory(true)
	else: hide_inventory()

func toggle_interrupts(toggle):
	if toggle:
		player_consumables.visible = false
		player_runes.visible = false
	else: hide_inventory()

func _on_consumables_button_toggled(toggled_on: bool) -> void:
	toggle_consumables(toggled_on)

func _on_side_deck_button_toggled(toggled_on: bool) -> void:
	toggle_side_deck(toggled_on)

func _on_runes_button_toggled(toggled_on: bool) -> void:
	toggle_runes(toggled_on)
