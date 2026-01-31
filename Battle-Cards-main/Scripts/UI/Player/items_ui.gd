extends Panel

@onready var player_consumables = $"../PlayerConsumables"
@onready var player_runes = $"../PlayerRunes"
@onready var player_gadgets = $"../PlayerGadgets"
@onready var player_interrupts = $"../PlayerInterrupts"

func hide_inventory():
	player_consumables.visible = false
	player_runes.visible = false
	player_gadgets.visible = false
	player_interrupts.visible = false

func toggle_consumables(toggle):
	if toggle:
		player_consumables.visible = true
		player_runes.visible = false
		player_gadgets.visible = false
		player_interrupts.visible = false
	else: hide_inventory()

func toggle_runes(toggle):
	if toggle:
		player_consumables.visible = false
		player_runes.visible = true
		player_gadgets.visible = false
		player_interrupts.visible = false
	else: hide_inventory()

func toggle_gadgets(toggle):
	if toggle:
		player_consumables.visible = false
		player_runes.visible = false
		player_gadgets.visible = true
		player_interrupts.visible = false
	else: hide_inventory()

func toggle_interrupts(toggle):
	if toggle:
		player_consumables.visible = false
		player_runes.visible = false
		player_gadgets.visible = false
		player_interrupts.visible = true
	else: hide_inventory()

	
func _on_consumables_button_toggled(toggled_on: bool) -> void:
	toggle_consumables(toggled_on)


func _on_interrupts_button_toggled(toggled_on: bool) -> void:
	toggle_interrupts(toggled_on)


func _on_gadgets_button_toggled(toggled_on: bool) -> void:
	toggle_gadgets(toggled_on)


func _on_runes_button_toggled(toggled_on: bool) -> void:
	toggle_runes(toggled_on)
