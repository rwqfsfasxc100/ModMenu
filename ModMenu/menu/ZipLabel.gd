extends OptionButton


func _ready():
	addItems()
	
func addItems():
	add_item("MODMENU_SETTINGS_ZIPDISPLAY_ZIP")
	add_item("MODMENU_SETTINGS_ZIPDISPLAY_PATH")
	add_item("MODMENU_SETTINGS_ZIPDISPLAY_NONE")
	selected = Settings.ModMenu["mainSettings"]["zipNameDisplay"]

func _on_OptionButton_visibility_changed():
	selected = Settings.ModMenu["mainSettings"]["zipNameDisplay"]

func _on_OptionButton_item_selected(index):
	Settings.ModMenu["mainSettings"]["zipNameDisplay"] = index
