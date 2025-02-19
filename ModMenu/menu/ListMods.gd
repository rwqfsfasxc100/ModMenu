extends Node

const modButton = preload("res://ModMenu/menu/buttons/ModButtonAdvanced.tscn")

var modDependancy = []
var tempFolderPath = "user://.DVModMenuTemp/"
var hasModMenuTemp = false
var disabledMods = []
var disabledFolderContents = []

func _ready():
	checkTempFolderExists()
	getMods()
	handleDisableMods()
	clearTempFolderCache()


func getMods():
	var gameInstallDirectory = OS.get_executable_path().get_base_dir()
	if OS.get_name() == "OSX":
		gameInstallDirectory = gameInstallDirectory.get_base_dir().get_base_dir().get_base_dir()
	var modPathPrefix = gameInstallDirectory.plus_file("mods")
	Debug.l("Mod Menu List: Registering and verifying contents of the mods folder")
	scanForDisabledMods(modPathPrefix)
	var dir = Directory.new()
	dir.open(modPathPrefix)
	var dirName = dir.get_current_dir()
	dir.list_dir_begin(true)
	while true:
		var fileName = dir.get_next()
		dirName = dir.get_current_dir()
		Debug.l(fileName)
		if fileName == "":
			break
		if dir.current_is_dir():
			continue
		var modFSPath = modPathPrefix.plus_file(fileName)
		var modGlobalPath = ProjectSettings.globalize_path(modFSPath)
		if not ProjectSettings.load_resource_pack(modGlobalPath, true):
			Debug.l("Mod Menu List: %s failed to register." % fileName)
			continue
		modDependancy.append(fileName)
		Debug.l("Mod Menu List: %s registered." % fileName)
	Debug.l("Mod Menu List: Finished verification of mod folder.")
	
	# listing mods to the button list
	
	for mod in modDependancy:
		var mDir = modPathPrefix + "/"
		var modTruncate = mod.split(".zip")
		var modDir = mDir + mod
		var modData = getModMain(modDir)
		var modDataSplit = modData.split("\n")
		var modNameDespace = modDataSplit[0].split(" ")
		var modNameDespaceSize = modNameDespace.size()
		var modNamePatched = "".join(modNameDespace)
		var nameFormatted = modNamePatched + "~" + modDataSplit[2]
		var button = modButton.instance()
		if modData != null:
			button.editor_description = modData
			button.set_name(nameFormatted)
		else:
			button.set_name(modTruncate[0])
			button.text = modTruncate[0]
		add_child(button)
		Debug.l("Added %s to ModMenu list" % mod)

var lineArray = []

func load_file(modDir, zipDir):
	var dirSplit = zipDir.split("/")
	var dirSplitSize = dirSplit.size()
	var fallbackDir = dirSplit[dirSplitSize - 1]
	var f = File.new()
	f.open(modDir, File.READ)
	var modFolderSplit = modDir.split("/ModMain.gd")
	var modFolderCount = modFolderSplit.size()
	var separateModFolderDir = modFolderSplit[modFolderCount - 2].split("/")
	var modFolderSecondCount = separateModFolderDir.size()
	var modFolder = separateModFolderDir[modFolderSecondCount - 1]
	var nameCheck = 0
	var modName = ""
	var prioCheck = 0
	var modPrio = 0
	var content = f.get_as_text(true)
	var modMainLines = content.split("\n")
	for l in modMainLines:
		Debug.l("Checking for MOD_NAME constant")
		var modNameCheck = l.split("const MOD_NAME = ")
		var modNameCheckSize = modNameCheck.size()
		if modNameCheckSize >= 2:
			var splitName = array_to_string(modNameCheck[1].split("\""))
			while splitName.begins_with(" "):
				var beginningSpaceRemover = splitName.split(" ")
				splitName = array_to_string(beginningSpaceRemover[1])
			while splitName.ends_with(" "):
				var endSpaceRemover = splitName.split(" ")
				splitName = array_to_string(endSpaceRemover[0])
			nameCheck += 1
			modName = splitName
		Debug.l("Checking for MOD_PRIORITY constant")
		var priorityCheck = l.split("const MOD_PRIORITY = ")
		var priorityCheckSize = priorityCheck.size()
		if priorityCheckSize >= 2:
			prioCheck += 1
			modPrio = priorityCheck[1]
		if not nameCheck == 1:
			modName = fallbackDir
		if not prioCheck == 1:
			modPrio = 0
	var prioStr = String(modPrio)
	var compiledData = modName + "\n" + fallbackDir + "\n" + prioStr + "\n" + modFolder
	return compiledData

func getModMain(file):
	var gdunzip = load("res://vendor/gdunzip.gd").new()
	gdunzip.load(file)
	for filePath in gdunzip.files:
		var fileEntry = filePath.get_file().to_lower()
		if fileEntry.begins_with("modmain") and fileEntry.ends_with(".gd"):
			var modGlobalPath = "res://" + filePath
			Debug.l("ModMenu Loader Storage: Loading %s" % modGlobalPath)
			var modData = load_file(modGlobalPath, file)
			if modGlobalPath != null:
				return modData
			else:
				return null

func checkTempFolderExists(): 
	var directory = Directory.new()
	if directory.dir_exists(tempFolderPath):
		Debug.l("Temp directory exists")
	else:
		var error_code = directory.make_dir_recursive(tempFolderPath)
		if error_code != OK:
			Debug.l("Failed to make temp folder")

func scanForDisabledMods(directory):
	Debug.l("Looking for disabled mods")
	var dir = Directory.new()
	dir.open(directory)
	var dirName = dir.get_current_dir()
	dir.list_dir_begin(true)
	while true:
		var fileName = dir.get_next()
		dirName = dir.get_current_dir()
		if fileName.ends_with(".disabled"):
			disabledMods.append(fileName)
		Debug.l("Disabled mod: " + fileName)
		if fileName == "":
			break
		if dir.current_is_dir():
			continue
			
	for mod in disabledMods:
		var copyDir = Directory.new()
		var folder = directory + "/" + mod
		copyDir.copy(folder, tempFolderPath + mod)
		var removeDisabledTag = mod.split(".disabled")
		var renamedMod = removeDisabledTag[0]
		var moveDir = Directory.new()
		moveDir.rename(tempFolderPath + mod, tempFolderPath + renamedMod)
		disabledFolderContents.append(tempFolderPath + renamedMod)


func handleDisableMods():
	for mod in disabledFolderContents:
		var disabledModData = getModMain(mod)
		disabledModData = disabledModData + "\ndisabled"
		var splidDisabledModData = disabledModData.split("\n")
		if disabledModData != null:
			var button = modButton.instance()
			button.editor_description = disabledModData
			button.set_name(splidDisabledModData[0] + "~" + splidDisabledModData[2] + "~" + splidDisabledModData[4])
			add_child(button)
			pass


func array_to_string(arr: Array) -> String:
	var s = ""
	for i in arr:
		s += String(i)
	return s

func clearTempFolderCache():
	var dir = Directory.new()
	dir.open(tempFolderPath)
	var cache = []
	var dirName = dir.get_current_dir()
	dir.list_dir_begin(true)
	while true:
		var fileName = dir.get_next()
		dirName = dir.get_current_dir()
		cache.append(fileName)
		Debug.l("Clearing cache: " + fileName)
		if fileName == "":
			break
		if dir.current_is_dir():
			continue
	for m in cache:
		dir.remove(m)
