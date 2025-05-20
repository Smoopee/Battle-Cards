extends PopupPanel


func _input(event):
	if event.is_action_pressed("Inventory"):
		toggle_inventory()

func toggle_inventory():
	#From player screen to Inventory
	print("YO")
