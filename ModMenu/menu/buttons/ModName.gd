extends Button

onready var modData = get_parent().editor_description.split("\n")

func _ready():
	writeVars()
var zipString = ""
var modID = ""
func writeVars():
	var gameInstallDirectory = OS.get_executable_path().get_base_dir()
	if OS.get_name() == "OSX":
		gameInstallDirectory = gameInstallDirectory.get_base_dir().get_base_dir().get_base_dir()
	
	var modDir = gameInstallDirectory + "/mods/"
	var zipListType = Settings.ModMenu["mainSettings"]["zipNameDisplay"]
	if zipListType == 0:
		zipString = "\n" + TranslationServer.translate("MODMENU_MOD_ZIPFILE") + modData[1]
	if zipListType == 1:
		zipString = "\n" + TranslationServer.translate("MODMENU_MOD_ZIPFILE_FULL") + modDir + modData[1]
	if zipListType == 2:
		zipString = ""
	get_node("Label").text = modData[0]
	if not modData[15] == "MODMENU_ID_PLACEHOLDER":
		modID = TranslationServer.translate("MODMENU_ID_LABEL") % str(modData[15])
	else:
		modID = TranslationServer.translate("MODMENU_ID_PLACEHOLDER")
	
	get_node("Tooltip").editor_description = modData[0] + "\n" + modID + zipString

func _process(delta):
	var tooltip = Settings.ModMenu["mainSettings"]["accessibleTooltips"]
	if tooltip == 0:
		hint_tooltip = modData[0] + "\n" + modID + zipString
	else:
		hint_tooltip = ""
