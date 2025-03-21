extends Popup


var lastFocus = null
func _on_Popup_about_to_show():
	lastFocus = get_focus_owner()


func _on_MISSINGDEPSBUTTON_pressed():
	popup_centered()
