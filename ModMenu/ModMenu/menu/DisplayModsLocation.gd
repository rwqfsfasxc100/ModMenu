extends OptionButton


func _ready():
	addItems()
	
func addItems():
	add_item("MODMENU_SETTINGS_DISPLAY_DLC")
	add_item("MODMENU_SETTINGS_DISPLAY_TOOLTIPS")
	add_item("MODMENU_SETTINGS_DISPLAY_NONE")
	selected = Settings.ModMenu["mainSettings"]["displayLocation"]

func _on_displayLocation_item_selected(index):
	Settings.ModMenu["mainSettings"]["displayLocation"] = index

func _on_displayLocation_visibility_changed():
	selected = Settings.ModMenu["mainSettings"]["displayLocation"]

