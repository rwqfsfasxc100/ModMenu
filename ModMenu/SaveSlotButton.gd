extends "res://SaveSlotButton.gd"

func checkSave():
	.checkSave()
	if Settings.ModMenu["mainSettings"]["extendedSaves"]:
		get_parent().get_parent().get_parent().get_node("HBoxContainer2/Next").grab_focus()
