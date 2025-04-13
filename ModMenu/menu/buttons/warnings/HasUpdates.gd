extends Button

var updateDir = "user://cache/.Mod_Menu_Cache/updatecache/mod.updates"

var tempFolderPath = "user://cache/.Mod_Menu_Cache/currentmods/"

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
		
		var doesConcur = false
		
		var versionFromCurrent = currentMod[4]
		var versionFromDownload = data[2]
		var currentSplit = versionFromCurrent.split(".")
		var currentSplitSize = currentSplit.size()
		var downloadSplit = versionFromDownload.split(".")
		var downloadSplitSize = downloadSplit.size()
		if currentSplitSize == 1 and downloadSplitSize == 1:
			var c = compare(versionFromCurrent, versionFromDownload)
			if c:
				doesConcur = true
		elif currentSplitSize == downloadSplitSize:
			var index = 0
			while index +1 <= currentSplitSize:
				var c = compare(currentSplit[index],downloadSplit[index])
				if c:
					doesConcur = true
					break
				index += 1
		
		
		
		if doesConcur and data[0] == currentMod[15]:
			visible = true
			var dir = Directory.new()
			dir.open(tempFolderPath)
			if not dir.file_exists(currentMod[1].split(".zip")[0] + "_--_V_" + currentMod[4] + ".zip"):
				dir.copy(modPathPrefix + "/" + currentMod[1], tempFolderPath + currentMod[1].split(".zip")[0] + "_--_V_" + currentMod[4] + ".zip")
	
	
	
	
	if get_parent().get_node("CONFLICTBUTTON").visible == true:
		focus_neighbour_top = get_path_to(get_parent().get_node("CONFLICTBUTTON"))
	elif get_parent().get_node("CONFLICTBUTTON").visible == false and get_parent().get_node("MISSINGDEPSBUTTON").visible == true:
		focus_neighbour_top = get_path_to(get_parent().get_node("MISSINGDEPSBUTTON"))
	else:
		focus_neighbour_top = ""
	
	if get_parent().get_node("MISSINGDEPSBUTTON").visible == true:
		focus_neighbour_right = get_path_to(get_parent().get_node("MISSINGDEPSBUTTON"))
	else:
		focus_neighbour_right = get_path_to(get_parent().get_parent().get_parent().get_node("MODNAME"))
	


func compare(current, download):
	if int(download) > int(current):
		return true
	else:
		return false
