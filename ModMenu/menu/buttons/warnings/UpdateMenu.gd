extends Popup

func _on_UPDATE_pressed():
	popup_centered()

var lastFocus = null
func _on_Popup_about_to_show():
	lastFocus = get_focus_owner()
