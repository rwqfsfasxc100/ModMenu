extends "res://menu/ExtensionPopup.gd"



func _on_ExtensionPopup_visibility_changed():
	
	if visible:
		var viewportSize = get_parent().rect_size
		var py = OS.get_screen_size().y
		var size = rect_size
		rect_min_size.y = py
		rect_position.x = (viewportSize.x - size.x) / 2
		
