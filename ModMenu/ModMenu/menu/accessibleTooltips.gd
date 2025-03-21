extends OptionButton


func _ready():
	addItems()
	
func addItems():
	add_item("MODMENU_SETTINGS_ACCESSIBLE_DEFAULT")
	add_item("MODMENU_SETTINGS_ACCESSIBLE_TOP")
	add_item("MODMENU_SETTINGS_ACCESSIBLE_BELOW")
	selected = Settings.ModMenu["mainSettings"]["accessibleTooltips"]

func _on_OptionButton_visibility_changed():
	selected = Settings.ModMenu["mainSettings"]["accessibleTooltips"]

func _on_OptionButton_item_selected(index):
	Settings.ModMenu["mainSettings"]["accessibleTooltips"] = index

