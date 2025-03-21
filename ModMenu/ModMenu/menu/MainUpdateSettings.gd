extends OptionButton

func _ready():
	addItems()
	
func addItems():
	add_item("MODMENU_SETTINGS_UPDATER_NORMAL")
	add_item("MODMENU_SETTINGS_FETCH_PRE_RELEASES")
	add_item("MODMENU_SETTINGS_UPDATER_DISABLED")
	selected = Settings.ModMenu["mainSettings"]["updaterOption"]

func _on_OptionButton_item_selected(index):
	Settings.ModMenu["mainSettings"]["updaterOption"] = index


func _on_OptionButton_visibility_changed():
	selected = Settings.ModMenu["mainSettings"]["updaterOption"]
