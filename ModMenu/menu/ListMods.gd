extends Node

var Globals = preload("res://ModMenu/Globals.gd").new()




const modButton = preload("res://ModMenu/menu/buttons/ModButtonAdvanced.tscn")

var modDependancy = []
var tempFolderPath = "user://.Mod_Menu_Cache/"
var tempModPath = "disabled_mod_cache/"
var hasModMenuTemp = false
var disabledMods = []
var disabledFolderContents = []

func _ready():
	
	
	checkTempFolderExists()
	getMods()
	clearTempFolderCache()
	getModList()
	if get_child_count() >= 1:
		var NetHandle = load("res://ModMenu/menu/netcode/NetHandles.tscn").instance()
		get_parent().call_deferred("add_child",NetHandle)
	


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
		var modData = Globals.__get_mod_main(modDir, true)
		var modNameDespace = modData[0].split(" ")
		var modNameDespaceSize = modNameDespace.size()
		var modNamePatched = "".join(modNameDespace)
		var nameFormatted = modNamePatched + "~" + modData[2]
		var button = modButton.instance()
		var modDataConjoin = "\n".join(modData)
		if modData != null:
			button.editor_description = modDataConjoin
			button.set_name(nameFormatted)
		else:
			button.set_name(modTruncate[0])
			button.text = modTruncate[0]
		add_child(button)
		var buttonFolder = "res://" + modData[3] + "/ModMenu/button/"
		var dirCheck = Directory.new()
		if dirCheck.open(buttonFolder) == OK:
			var menuItem = load("res://" + modData[3] + "/ModMenu/menu/" + modData[3] + "Menu.tscn")
			if not menuItem == null:
				var initMenu = menuItem.instance()
				initMenu.name = modData[3]
				if get_parent().get_parent().get_parent().get_node("NoMargins").add_child(initMenu) == OK:
					continue
		Debug.l("Added %s to ModMenu list" % mod)


func checkTempFolderExists(): 
	var directory = Directory.new()
	if directory.dir_exists(tempFolderPath):
		Debug.l("Temp mod menu directory exists")
	else:
		var error_code = directory.make_dir_recursive(tempFolderPath)
		if error_code != OK:
			Debug.l("Failed to make temp folder")

func clearTempFolderCache():
	var dir = Directory.new()
	dir.open(tempFolderPath + tempModPath)
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
		if not m == "":
			dir.remove(m)


var manifestDict = {}


func getModList():
	var childCount = get_child_count()
	var currentChildNo = 0
	while currentChildNo < childCount:
		var childNodeData = get_child(currentChildNo).editor_description.split("\n")
		currentChildNo += 1
		if not childNodeData[15] == "MODMENU_ID_PLACEHOLDER":
			var dictForMerger = {
						childNodeData[15]: [
							childNodeData[0],
							childNodeData[1],
							childNodeData[3],
							childNodeData[4],
							childNodeData[6],
							childNodeData[7],
							Time.get_datetime_string_from_system()
							]
					}
			manifestDict.merge(dictForMerger)
		var modList = get_parent().get_node("InstalledMods").editor_description
		var validMods = get_parent().get_node("InstalledModsWithValidIDs").editor_description
		
		
		if not childNodeData[15] == "MODMENU_ID_PLACEHOLDER":
			modList = modList.to_lower() + childNodeData[15].to_lower() + "~||~" + childNodeData[1].to_lower() + "~||~" + childNodeData[4].to_lower() + "\n"
			get_parent().get_node("InstalledModsWithValidIDs").editor_description = validMods + childNodeData[15].to_lower() + "~||~" + childNodeData[1].to_lower() + "~||~" + childNodeData[4].to_lower() + "~||~" + childNodeData[7] + "\n"
		else:
			modList = modList.to_lower() + childNodeData[0].to_lower() + "~||~" + childNodeData[1].to_lower() + "~||~" + childNodeData[4].to_lower() + "\n"
		get_parent().get_node("InstalledMods").editor_description = modList
