extends CheckButton

func _toggled(how):
	Settings.ModMenu["mainSettings"]["reduceTitleClutter"] = how


func _visibility_changed():
	pressed = Settings.ModMenu["mainSettings"]["reduceTitleClutter"]
