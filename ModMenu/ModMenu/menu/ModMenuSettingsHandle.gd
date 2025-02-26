extends CheckButton

export  var setting = "mainSettings"
export  var section = "fetchPreReleases"

func _ready():
	connect("visibility_changed", self, "_visibility_changed")
	connect("toggled", self, "_toggled")
	
func _toggled(how):
	Settings.ModMenu[section][setting] = how

func _visibility_changed():
	pressed = Settings.ModMenu[section][setting]
