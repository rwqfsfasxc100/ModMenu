extends "res://menu/SettingsLayer.gd"



func _on_SettingsLayer_visibility_changed():
	
	if visible:
		var viewportSize = get_parent().rect_size
		var size = rect_size
		rect_position.x = (abs(viewportSize.x - size.x)) / 2
		rect_position.y = (abs(viewportSize.y - size.y)) / 2
