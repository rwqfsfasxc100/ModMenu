extends "res://Settings.gd"

# You may want to change many of the variable names to provide a unique identifier
# Make sure anything read by the ModMain is consistent with this file or they will not work
# These are default config values
# Any value not set in the config file will generate the missing values exactly as these are
var ModMenu = {
	"mainSettings":{
		"updatePrefs":2,
		"displayLocation":0,
		"updaterOption":0,
		"zipNameDisplay":0,
		"buttonDisplay":0,
		"accessibleTooltips":0,
		"savePage":1,
		"extendedSaves":true,
	},
	"debugStuffNotForTheSeeingEyes":{
		"":""
	},
}

# The config file name. Make sure you set something unique
var ModMenuPath = "user://ModMenusettings.cfg"
var ModMenuFile = ConfigFile.new()

func _ready():
	loadModMenuFromFile()
	saveModMenuToFile()


func saveModMenuToFile():
	for section in ModMenu:
		for key in ModMenu[section]:
			ModMenuFile.set_value(section, key, ModMenu[section][key])
	ModMenuFile.save(ModMenuPath)


func loadModMenuFromFile():
	var error = ModMenuFile.load(ModMenuPath)
	if error != OK:
		Debug.l("ModMenu: Error loading settings %s" % error)
		return 
	for section in ModMenu:
		for key in ModMenu[section]:
			ModMenu[section][key] = ModMenuFile.get_value(section, key, ModMenu[section][key])
