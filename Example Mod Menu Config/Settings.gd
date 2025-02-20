extends "res://Settings.gd"

# Mod version
const Example_Mod_Menu_Config_VERSION = "1.0.0"

# Default config values
var Example_Mod_Menu_Config = {
	"mainToggles":{
		"NOTE -":"- These are some configs taken from the mod Derelict Delights, and are purely reference as to how they're handled",
		"addEquipment":true,
		"addEvents":true,
		"addAgenda":true,
	}, 
	"eventToggles":{
		"addDerelicts":true,
		"addNewNPCMiners":true,
		"addHabitatUnderConstruction":true,
	},
	"agendaToggles":{
		"addHistorian":true,
	},
}


var Example_Mod_Menu_ConfigPath = "user://Example_Mod_Menu_Config_settings.cfg"
var Example_Mod_Menu_ConfigFile = ConfigFile.new()

func _ready():
	loadExample_Mod_Menu_ConfigFromFile()
	saveExample_Mod_Menu_ConfigToFile()


func saveExample_Mod_Menu_ConfigToFile():
	for section in Example_Mod_Menu_Config:
		for key in Example_Mod_Menu_Config[section]:
			Example_Mod_Menu_ConfigFile.set_value(section, key, Example_Mod_Menu_Config[section][key])
	Example_Mod_Menu_ConfigFile.save(Example_Mod_Menu_ConfigPath)


func loadExample_Mod_Menu_ConfigFromFile():
	var error = Example_Mod_Menu_ConfigFile.load(Example_Mod_Menu_ConfigPath)
	if error != OK:
		Debug.l("Example Mod Menu Config: Error loading settings %s" % error)
		return 
	for section in Example_Mod_Menu_Config:
		for key in Example_Mod_Menu_Config[section]:
			Example_Mod_Menu_Config[section][key] = Example_Mod_Menu_ConfigFile.get_value(section, key, Example_Mod_Menu_Config[section][key])
	loadExample_Mod_Menu_ConfigKeymapFromConfig()

# No examples directly given for keybinds, check Za'krin's ZKY mod for references for this
func loadExample_Mod_Menu_ConfigKeymapFromConfig():
	for action_name in Example_Mod_Menu_Config.input:
		InputMap.add_action(action_name)
		for key in Example_Mod_Menu_Config.input[action_name]:
			var event = InputEventKey.new()
			event.scancode = OS.find_scancode_from_string(key)
			InputMap.action_add_event(action_name, event)
	emit_signal("controlSchemeChaged")
