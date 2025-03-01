extends Node

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
		var buttonFolder = "res://" + modDataSplit[3] + "/ModMenu/button/"
		var dirCheck = Directory.new()
		if dirCheck.open(buttonFolder) == OK:
			var menuItem = load("res://" + modDataSplit[3] + "/ModMenu/menu/" + modDataSplit[3] + "Menu.tscn")
			if not menuItem == null:
				var initMenu = menuItem.instance()
				initMenu.name = modDataSplit[3]
				if get_parent().get_parent().get_parent().get_node("NoMargins").add_child(initMenu) == OK:
					continue
		Debug.l("Added %s to ModMenu list" % mod)

var lineArray = []
var manifestName = ""
var manifestId = ""
var manifestVersion = ""
var manifestDescription = ""
var manifestGroup = ""
var github_homepage = ""
var github_releases = ""
var discord_thread = ""
var nexus_page = ""
var donations_page = ""
var wiki_page = ""
var custom_link = ""
var custom_link_name = ""

func load_file(modDir, zipDir, hasManifest, manifestDirectory, hasIcon, iconDir):
	manifestName = ""
	manifestId = ""
	manifestVersion = ""
	manifestDescription = ""
	manifestGroup = ""
	github_homepage = ""
	github_releases = ""
	discord_thread = ""
	nexus_page = ""
	donations_page = ""
	wiki_page = ""
	custom_link = "MODMENU_CUSTOM_LINK_PLACEHOLDER"
	custom_link_name = "MODMENU_CUSTOM_LINK_NAME_PLACEHOLDER"
	var dirSplit = zipDir.split("/")
	var dirSplitSize = dirSplit.size()
	var fallbackDir = dirSplit[dirSplitSize - 1]
	var f = File.new()
	if hasManifest:
		f.open(manifestDirectory, File.READ)
		var manifestData = loadManifestFromFile(manifestDirectory)
		manifestName = manifestData["package"]["name"]
		manifestId = manifestData["package"]["id"]
		manifestVersion = manifestData["package"]["version"]
		manifestDescription = manifestData["package"]["description"]
		manifestGroup = manifestData["package"]["group"]
		github_homepage = manifestData["package"]["github_homepage"]
		github_releases = manifestData["package"]["github_releases"]
		discord_thread = manifestData["package"]["discord_thread"]
		nexus_page = manifestData["package"]["nexus_page"]
		donations_page = manifestData["package"]["donations_page"]
		wiki_page = manifestData["package"]["wiki_page"]
		custom_link = manifestData["package"]["custom_link"]
		custom_link_name = manifestData["package"]["custom_link_name"]
		f.close()
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
	var modVer = ""
	var verCheck = 0
	var content = f.get_as_text(true)
	var modMainLines = content.split("\n")
	for l in modMainLines:
		if not hasManifest and manifestName == "":
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
				nameCheck = 1
				modName = splitName
		else:
			nameCheck = 1
			modName = manifestName
		var priorityCheck = l.split("const MOD_PRIORITY = ")
		var priorityCheckSize = priorityCheck.size()
		if priorityCheckSize >= 2:
			prioCheck += 1
			modPrio = priorityCheck[1]
		if not nameCheck == 1:
			modName = fallbackDir
		if not prioCheck == 1:
			modPrio = 0
		var versionCheck = l.split("const MOD_VERSION = ")
		var versionCheckSize = versionCheck.size()
		if not manifestVersion == "":
			verCheck = 1
			modVer = manifestVersion
		elif versionCheckSize >= 2 and not manifestVersion == modVer:
			verCheck = 1
			modVer = versionCheck[1]
		else:
			modVer = "unknown"
	var prioStr = String(modPrio)
	var ver = ""
	if verCheck == 1:
		ver = modVer
	else:
		ver = "unknown"
	var verData = String(ver)
	if manifestDescription == null or manifestDescription == "":
		manifestDescription = "MODMENU_DESCRIPTION_PLACEHOLDER"
	if manifestGroup == null or manifestGroup == "":
		manifestGroup = "MODMENU_GROUP_PLACEHOLDER"
	if manifestId == null or manifestId == "":
		manifestId = "MODMENU_ID_PLACEHOLDER"
	if github_homepage == null or github_homepage == "":
		github_homepage = "MODMENU_GITHUB_HOMEPAGE_PLACEHOLDER"
	if github_releases == null or github_releases == "":
		github_releases = "MODMENU_GITHUB_RELEASES_PLACEHOLDER"
	if discord_thread == null or discord_thread == "":
		discord_thread = "MODMENU_DISCORD_PLACEHOLDER"
	if nexus_page == null or nexus_page == "":
		nexus_page = "MODMENU_NEXUS_PLACEHOLDER"
	if donations_page == null or donations_page == "":
		donations_page = "MODMENU_DONATIONS_PLACEHOLDER"
	if wiki_page == null or wiki_page == "":
		wiki_page = "MODMENU_WIKI_PLACEHOLDER"
	if custom_link == null or custom_link == "":
		custom_link = "MODMENU_CUSTOM_LINK_PLACEHOLDER"
	if custom_link_name == null or custom_link_name == "":
		custom_link_name = "MODMENU_CUSTOM_LINK_NAME_PLACEHOLDER"
	if hasIcon:
		iconDir = iconDir
	else:
		iconDir = "empty"
	var compiledData = modName + "\n" + fallbackDir + "\n" + prioStr + "\n" + modFolder + "\n" + verData + "\n" + manifestDescription + "\n" + github_homepage + "\n" + github_releases + "\n" + discord_thread + "\n" + nexus_page + "\n" + donations_page + "\n" + wiki_page + "\n" + custom_link + "\n" + custom_link_name + "\n" + iconDir
	return compiledData

func getModMain(file):
	var hasManifest = false
	var manifestDir = ""
	var hasIcon = false
	var iconDir = ""
	var gdunzip = load("res://vendor/gdunzip.gd").new()
	gdunzip.load(file)
	for filePath in gdunzip.files:
		var fileEntry = filePath.get_file().to_lower()
		if fileEntry.begins_with("mod") and fileEntry.ends_with(".manifest"):
			var manifestGlobalPath = "res://" + filePath
			Debug.l("ModMenu Loader Storage: Loading manifest file @ %s" % manifestGlobalPath)
			hasManifest = true
			manifestDir = manifestGlobalPath
		if fileEntry.begins_with("icon") and fileEntry.ends_with(".stex"):
			var iconGlobalPath = "res://" + filePath
			Debug.l("ModMenu Loader Storage: Loading manifest file @ %s" % iconGlobalPath)
			hasIcon = true
			iconDir = iconGlobalPath
		if fileEntry.begins_with("modmain") and fileEntry.ends_with(".gd"):
			var modGlobalPath = "res://" + filePath
			Debug.l("ModMenu Loader Storage: Loading ModMain file @ %s" % modGlobalPath)
			var modData = load_file(modGlobalPath, file, hasManifest, manifestDir, hasIcon, iconDir)
			if modGlobalPath != null:
				return modData
			else:
				return null

func checkTempFolderExists(): 
	var directory = Directory.new()
	if directory.dir_exists(tempFolderPath):
		Debug.l("Temp mod menu directory exists")
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
	
	var tempModDir = Directory.new()
	if tempModDir.dir_exists(tempFolderPath + tempModPath):
		Debug.l("Temp directory exists")
	else:
		var error_code = tempModDir.make_dir_recursive(tempFolderPath + tempModPath)
		if error_code != OK:
			Debug.l("Failed to make temp folder")
	for mod in disabledMods:
		var copyDir = Directory.new()
		var folder = directory + "/" + mod
		copyDir.copy(folder, tempFolderPath  + tempModPath + mod)
		var removeDisabledTag = mod.split(".disabled")
		var renamedMod = removeDisabledTag[0]
		var moveDir = Directory.new()
		moveDir.rename(tempFolderPath + tempModPath + mod, tempFolderPath + tempModPath + renamedMod)
		disabledFolderContents.append(tempFolderPath + tempModPath + renamedMod)


func handleDisableMods():
	for mod in disabledFolderContents:
		var disabledModData = getModMain(mod)
		disabledModData = disabledModData + "\ndisabled"
		var splidDisabledModData = disabledModData.split("\n")
		if disabledModData != null:
			var button = modButton.instance()
			button.editor_description = disabledModData
			button.set_name(splidDisabledModData[0] + "~" + splidDisabledModData[2] + "~" + splidDisabledModData[15])
			add_child(button)
			pass


func array_to_string(arr: Array) -> String:
	var s = ""
	for i in arr:
		s += String(i)
	return s

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


var manifestConfig = {
	"package":{
		"id":null,
		"name":null,
		"version":"unknown",
		"description":"MODMENU_DESCRIPTION_PLACEHOLDER",
		"group":"",
		"github_homepage":"",
		"github_releases":"",
		"discord_thread":"",
		"nexus_page":"",
		"donations_page":"",
		"wiki_page":"",
		"custom_link":"",
		"custom_link_name":"",
	}
}
var manifestFile = ConfigFile.new()


func loadManifestFromFile(manifest):
	var error = manifestFile.load(manifest)
	if error != OK:
		Debug.l("Derelict Delights: Error loading settings %s" % error)
		return 
	for section in manifestConfig:
		for key in manifestConfig[section]:
			manifestConfig[section][key] = manifestFile.get_value(section, key, manifestConfig[section][key])
	return manifestConfig
