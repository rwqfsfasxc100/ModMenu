extends OptionButton


func _ready():
	addItems()
	
func addItems():
	add_item("MODMENU_SETTINGS_BUTTON_LOCATION_BELOW")
	add_item("MODMENU_SETTINGS_BUTTON_LOCATION_NEXT")
	add_item("MODMENU_SETTINGS_BUTTON_LOCATION_ALONE")
	selected = Settings.ModMenu["mainSettings"]["buttonDisplay"]

func _on_OptionButton_visibility_changed():
	selected = Settings.ModMenu["mainSettings"]["buttonDisplay"]

func _on_OptionButton_item_selected(index):
	Settings.ModMenu["mainSettings"]["buttonDisplay"] = index
