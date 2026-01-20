extends Node2D

var card_in_slot = false
@onready var slot_number = $SlotNumber


func change_slot_number(value):
	$SlotNumber.text = str(value)
