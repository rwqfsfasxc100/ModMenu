extends MarginContainer

var modDependancy = []

func _ready():
	getMods()

func getMods():
	var gameInstallDirectory = OS.get_executable_path().get_base_dir()
	if OS.get_name() == "OSX":
		gameInstallDirectory = gameInstallDirectory.get_base_dir().get_base_dir().get_base_dir()
	var modPathPrefix = gameInstallDirectory.plus_file("mods")
	Debug.l("Mod Menu List: Registering and verifying contents of the mods folder")
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
		var menuItem = load("res://" + modDataSplit[3] + "/ModMenu/menu/" + modDataSplit[3] + "Menu.tscn")
		if not menuItem == null:
			var initMenu = menuItem.instance()
			initMenu.name = modDataSplit[3]
			if self.add_child(initMenu) == OK:
				continue
		Debug.l("Added %s to ModMenu list" % mod)
		
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

func array_to_string(arr: Array) -> String:
	var s = ""
	for i in arr:
		s += String(i)
	return s
