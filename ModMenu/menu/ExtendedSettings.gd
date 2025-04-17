extends CheckButton


func _toggled(how):
	Settings.ModMenu["mainSettings"]["extendedSaves"] = how

func _visibility_changed():
	pressed = Settings.ModMenu["mainSettings"]["extendedSaves"]
