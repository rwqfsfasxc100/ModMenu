extends Popup


var lastFocus = null
func _on_Popup_about_to_show():
	lastFocus = get_focus_owner()


func _on_CONFLICTBUTTON_pressed():
	popup_centered()
