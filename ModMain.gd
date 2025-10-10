extends Node

# Set mod priority if you want it to load before/after other mods
# Mods are loaded from lowest to highest priority, default is 0
const MOD_PRIORITY = 2147483648
# Name of the mod, used for writing to the logs
const MOD_NAME = "Mod Menu"
const MOD_VERSION = "1.3.14"
# Path of the mod folder, automatically generated on runtime
var modPath:String = get_script().resource_path.get_base_dir() + "/"
# Required var for the replaceScene() func to work
var _savedObjects := []

var modConfig = {}
#Initializes the configuration variable. Used by loadSettings.

# Initialize the mod
# This function is executed before the majority of the game is loaded
# Only the Tool and Debug AutoLoads are available
# Script and scene replacements should be done here, before the originals are loaded
func _init(modLoader = ModLoader):
	l("Initializing DLC")
	
	var self_path = self.get_script().get_path()
	var self_directory = self_path.split(self_path.split("/")[self_path.split("/").size() - 1])[0]
	var self_check = load(self_directory + "mod_checker_script.tscn").instance()
	add_child(self_check)
# Modify Settings.gd first so we can load config and DLC
	installScriptExtension("Settings.gd")
	loadSettings()
	loadDLC() # preloads DLC as things may break if this isn't done
	installScriptExtension("SaveSlotButton.gd")
	load("res://ModMenu/menu/ModMenuLayer.tscn")
	replaceScene("PauseLayer.tscn")
	replaceScene("enceladus/PauseLayerEnceladus.tscn")
# Do stuff on ready
# At this point all AutoLoads are available and the game is loaded
func _ready():
	l("Readying")
	replaceScene("TitleScreen.tscn")
	updateTL("i18n/en.txt", "|")
	updateTL("i18n/stats_en.txt", "|")
	l("Ready")
	
# This function is a helper to provide any file configurations to your mod
# You may want to replace any "Example" text with your own identifier to make it unique
# Check the example Settings.gd file for how to setup that side of it
func loadSettings():
	l(MOD_NAME + ": Loading mod settings")
	var settings = load("res://Settings.gd").new()
	settings.loadModMenuFromFile()
	settings.saveModMenuToFile()
	modConfig = settings.ModMenu
	l(MOD_NAME + ": Current settings: %s" % modConfig)
	settings.queue_free()
	l(MOD_NAME + ": Finished loading settings")

# Helper script to load translations using csv format
# `path` is the path to the transalation file
# `delim` is the symbol used to seperate the values
# example usage: updateTL("i18n/translation.txt", "|")
func updateTL(path:String, delim:String = ","):
	path = str(modPath + path)
	l("Adding translations from: %s" % path)
	var tlFile:File = File.new()
	tlFile.open(path, File.READ)

	var translations := []

	var csvLine := tlFile.get_line().split(delim)
	l("Adding translations as: %s" % csvLine)
	for i in range(1, csvLine.size()):
		var translationObject := Translation.new()
		translationObject.locale = csvLine[i]
		translations.append(translationObject)

	while not tlFile.eof_reached():
		csvLine = tlFile.get_csv_line(delim)

		if csvLine.size() > 1:
			var translationID := csvLine[0]
			for i in range(1, csvLine.size()):
				translations[i - 1].add_message(translationID, csvLine[i].c_unescape())
			l("Added translation: %s" % csvLine)

	tlFile.close()

	for translationObject in translations:
		TranslationServer.add_translation(translationObject)

	l("Translations Updated")


# Helper function to extend scripts
# Loads the script you pass, checks what script is extended, and overrides it
func installScriptExtension(path:String):
	var childPath:String = str(modPath + path)
	var childScript:Script = ResourceLoader.load(childPath)

	childScript.new()

	var parentScript:Script = childScript.get_base_script()
	var parentPath:String = parentScript.resource_path

	l("Installing script extension: %s <- %s" % [parentPath, childPath])

	childScript.take_over_path(parentPath)


# Helper function to replace scenes
# Can either be passed a single path, or two paths
# With a single path, it will replace the vanilla scene in the same relative position
func replaceScene(newPath:String, oldPath:String = ""):
	l("Updating scene: %s" % newPath)

	if oldPath.empty():
		oldPath = str("res://" + newPath)

	newPath = str(modPath + newPath)

	var scene := load(newPath)
	scene.take_over_path(oldPath)
	_savedObjects.append(scene)
	l("Finished updating: %s" % oldPath)


# Instances Settings.gd, loads DLC, then frees the script.
func loadDLC():
	l("Preloading DLC as workaround")
	var DLCLoader:Settings = preload("res://Settings.gd").new()
	DLCLoader.loadDLC()
	DLCLoader.queue_free()
	l("Finished loading DLC")


# Func to print messages to the logs
func l(msg:String, title:String = MOD_NAME, version:String = MOD_VERSION):
	Debug.l("[%s V%s]: %s" % [title, version, msg])
	
	
# Func to scan the mods folder and return any files. Useful for checking dependancies. 
var modDependancy = []
func modsInstalled():
	var gameInstallDirectory = OS.get_executable_path().get_base_dir()
	if OS.get_name() == "OSX":
		gameInstallDirectory = gameInstallDirectory.get_base_dir().get_base_dir().get_base_dir()
	var modPathPrefix = gameInstallDirectory.plus_file("mods")
	l(MOD_NAME + ": Registering and verifying contents of the mods folder")
	var dir = Directory.new()
	dir.open(modPathPrefix)
	var dirName = dir.get_current_dir()
	dir.list_dir_begin(true)
	while true:
		var fileName = dir.get_next()
		dirName = dir.get_current_dir()
		l(fileName)
		if fileName == "":
			break
		if dir.current_is_dir():
			continue
		var modFSPath = modPathPrefix.plus_file(fileName)
		var modGlobalPath = ProjectSettings.globalize_path(modFSPath)
		if not ProjectSettings.load_resource_pack(modGlobalPath, true):
			l(MOD_NAME + ": %s failed to register." % fileName)
			continue
		var trueFileName = modFSPath.split("/")
		var trueFileNameLength = trueFileName.size()
		var getTrueFileName = trueFileName[trueFileNameLength - 1]
		modDependancy.append(getTrueFileName)
		l(MOD_NAME + ": %s registered." % fileName)
	l(MOD_NAME + ": Finished verification of mod folder.")

