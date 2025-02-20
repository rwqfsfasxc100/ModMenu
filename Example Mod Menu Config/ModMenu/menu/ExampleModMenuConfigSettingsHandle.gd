extends CheckButton

export  var setting = "addEquipment"
export  var section = "mainToggles"

func _ready():
	connect("visibility_changed", self, "_visibility_changed")
	connect("toggled", self, "_toggled")
	
func _toggled(how):
	Settings.Example_Mod_Menu_Config[section][setting] = how

func _visibility_changed():
	pressed = Settings.Example_Mod_Menu_Config[section][setting]
