extends Button

func _ready():
	pressed = Settings.ModMenu["mainSettings"]["showDangerousSettings"]
	var parent = get_parent().get_parent().get_parent()
	if pressed:
		parent.rect_size.y = 460
		parent.get_child(0).rect_size.y = 458
		parent.get_child(0).get_child(0).rect_size.y = 458
		parent.rect_position.y = 103
	else:
		parent.rect_size.y = 290
		parent.get_child(0).rect_size.y = 286
		parent.get_child(0).get_child(0).rect_size.y = 286
		parent.rect_position.y = 188
	vis(pressed)

func _on_showDangerousSettings_toggled(button_pressed):
	Settings.ModMenu["mainSettings"]["showDangerousSettings"] = button_pressed
	vis(pressed)
	var parent = get_parent().get_parent().get_parent()
	if pressed:
		parent.rect_size.y = 460
		parent.get_child(0).rect_size.y = 458
		parent.get_child(0).get_child(0).rect_size.y = 458
		parent.rect_position.y = 103
	else:
		parent.rect_size.y = 290
		parent.get_child(0).rect_size.y = 286
		parent.get_child(0).get_child(0).rect_size.y = 286
		parent.rect_position.y = 188
	Settings.saveModMenuToFile()

func _visibility_changed():
	pressed = Settings.ModMenu["mainSettings"]["showDangerousSettings"]
	var parent = get_parent().get_parent().get_parent()
	if pressed:
		parent.rect_size.y = 460
		parent.get_child(0).rect_size.y = 458
		parent.get_child(0).get_child(0).rect_size.y = 458
		parent.rect_position.y = 103
	else:
		parent.rect_size.y = 290
		parent.get_child(0).rect_size.y = 286
		parent.get_child(0).get_child(0).rect_size.y = 286
		parent.rect_position.y = 188
	vis(pressed)

func vis(toggle):
	get_parent().get_node("DangerSeparator").visible = toggle
	get_parent().get_node("ClearCache").visible = toggle
	get_parent().get_node("ClearCFG").visible = toggle
	get_parent().get_node("ClearMMCFG").visible = toggle
	
