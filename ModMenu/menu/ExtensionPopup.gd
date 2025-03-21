extends "res://menu/ExtensionPopup.gd"



func _on_ExtensionPopup_visibility_changed():
	
	if visible:
		var viewportSize = get_parent().rect_size
		var size = rect_size
		rect_position = (viewportSize - size) / 2
