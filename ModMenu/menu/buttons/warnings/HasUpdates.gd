extends Button

var updateDir = "user://.Mod_Menu_Cache/updatecache/mod.updates"

var tempFolderPath = "user://.Mod_Menu_Cache/currentmods/"

var modPathPrefix = ""

var Globals = preload("res://ModMenu/Globals.gd").new()

func _ready():
	visible = false
	
	Globals.__check_folder_exists(tempFolderPath)
	
	var gameInstallDirectory = OS.get_executable_path().get_base_dir()
	if OS.get_name() == "OSX":
		gameInstallDirectory = gameInstallDirectory.get_base_dir().get_base_dir().get_base_dir()
	modPathPrefix = gameInstallDirectory.plus_file("mods")


func _physics_process(delta):
	var thisModData = get_parent().get_parent().get_parent().editor_description
	var file = File.new()
	file.open(updateDir, File.READ)
	var currentUpdates = file.get_as_text()
	file.close()
	var mods = currentUpdates.split("\n")
	var currentMod = thisModData.split("\n")
	for mod in mods:
		if mod == "":
			return
		var data = mod.split("~||~")
		if data[2] > currentMod[4] and data[0] == currentMod[15]:
			visible = true
			var dir = Directory.new()
			dir.open(tempFolderPath)
			if not dir.file_exists(currentMod[1].split(".zip")[0] + "_--_V_" + currentMod[4] + ".zip"):
				dir.copy(modPathPrefix + "/" + currentMod[1], tempFolderPath + currentMod[1].split(".zip")[0] + "_--_V_" + currentMod[4] + ".zip")
