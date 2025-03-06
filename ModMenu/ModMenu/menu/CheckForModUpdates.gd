extends OptionButton

func _ready():
	addItems()
	
func addItems():
	add_item("MODMENU_SETTINGS_UPDATE_GITHUB")
	add_item("MODMENU_SETTINGS_UPDATE_DOWNLOAD")
	add_item("MODMENU_SETTINGS_UPDATE_EVERYTHING")
	selected = Settings.ModMenu["mainSettings"]["updatePrefs"]

func _on_OptionButton_item_selected(index):
	Settings.ModMenu["mainSettings"]["updatePrefs"] = index


func _on_OptionButton_visibility_changed():
	selected = Settings.ModMenu["mainSettings"]["updatePrefs"]
