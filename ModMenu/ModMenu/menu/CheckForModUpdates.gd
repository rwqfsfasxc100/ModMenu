extends OptionButton

func _ready():
	addItems()
	
func addItems():
	add_item("MODMENU_SETTINGS_UPDATE_EVERY_0")
	add_item("MODMENU_SETTINGS_UPDATE_EVERY_1")
	add_item("MODMENU_SETTINGS_UPDATE_EVERY_2")
	add_item("MODMENU_SETTINGS_UPDATE_EVERY_3")
	add_item("MODMENU_SETTINGS_UPDATE_EVERY_4")
	add_item("MODMENU_SETTINGS_UPDATE_EVERY_5")
	add_item("MODMENU_SETTINGS_UPDATE_EVERY_6")
	add_item("MODMENU_SETTINGS_UPDATE_EVERY_7")
	selected = Settings.ModMenu["mainSettings"]["updateCheckerDelay"]

func _on_OptionButton_item_selected(index):
	if Settings.ModMenu["mainSettings"]["updateCheckerDelay"] == 7 and not index == 7:
		Settings.ModMenu["debugStuffNotForTheSeeingEyes"]["lastUpdateCheckPerformedAt"] == Time.get_datetime_string_from_system(true)
	Settings.ModMenu["mainSettings"]["updateCheckerDelay"] = index


func _on_OptionButton_visibility_changed():
	selected = Settings.ModMenu["mainSettings"]["updateCheckerDelay"]
