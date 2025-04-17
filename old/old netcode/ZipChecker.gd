extends Node

var Globals = preload("res://ModMenu/Globals.gd").new()




var cacheExtension = ".modmenucache"
var tempFolderPath = "user://cache/.Mod_Menu_Cache/"
var cacheFolderPath = "mod_update_cache/"
var fileStoreDir = "mod_zip_cache/"
var zipFolderPath = "current_update_zips/"
var hasFetchedValidMods = false
var persistFile = tempFolderPath + cacheFolderPath + "persist.current" + cacheExtension
var persistFileStatic = tempFolderPath + cacheFolderPath + "persist" + cacheExtension

func _ready():
	pass # Replace with function body.
	
var zipList = []

func onCall():
	Debug.l("Mod Menu Update Checker: the ZIPCHECKER has been awakened")
	var modIDFromFile = getModsForUpdating()
	if modIDFromFile == "":
		Debug.l("Mod Menu Update Checker: No mods slated for update, exiting")
		return
	Debug.l("Mod Menu Update Checker: mods slated for update:\n" + modIDFromFile)
	var persistData = loadStaticPersistFile()
	var modIDs = modIDFromFile.split("\n")
	var modIDcount = modIDs.size()
	var dir = Directory.new()
	var modPathPrefix = tempFolderPath + fileStoreDir
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
			Debug.l("Mod Menu Update Checker: %s failed to register." % fileName)
			continue
		zipList.append(fileName)
		Debug.l("Mod Menu Update Checker: %s registered." % fileName)
	Debug.l("Mod Menu Update Checker: finished going though folder (this is so inefficient idk why i'm calling this again)")
	for mod in zipList:
		
		var mDir = modPathPrefix + "/"
		var modTruncate = mod.split(".zip")
		var modDir = mDir + mod
		var modData = getModManifest(modDir).split("\n")
		var idForFetchedMod = modData[0]
		var verForFetchedMod = modData[1]
		var currentModVersion = persistData[idForFetchedMod][3]
		var currentModFolder = persistData[idForFetchedMod][2]
		var fetchedVerCut = verForFetchedMod.substr(0, currentModVersion.length())
		var currentVersion = currentModVersion.to_utf8()
		var currentVerArray = []
		for m in currentVersion:
			currentVerArray.append(m)
		var currentVerFinal = Globals.__array_to_string(currentVerArray)
		var fetchedVersion = fetchedVerCut.to_utf8()
		var fetchedVerArray = []
		for m in fetchedVersion:
			fetchedVerArray.append(m)
		var fetchedVerFinal = Globals.__array_to_string(fetchedVerArray)
		if fetchedVerFinal > currentVerFinal:
			dir = Directory.new()
			dir.copy(tempFolderPath + fileStoreDir + mod, tempFolderPath + zipFolderPath + mod)
			var file = File.new()
			file.open("res://" + currentModFolder + "/update.txt", File.WRITE)
			file.store_string(fetchedVerFinal)
			file.close()
			var parentEditorText = get_parent().editor_description
			get_parent().editor_description = parentEditorText + idForFetchedMod + "\n"
	
	
	
	
func getModsForUpdating():
	var filePath = tempFolderPath + cacheFolderPath + "modsSlatedForUpdate" + cacheExtension
	var fileCheck = File.new()
	fileCheck.open(filePath, File.READ)
	var content = fileCheck.get_as_text()
	fileCheck.close()
	return str(content)



func getModManifest(file):
	var hasManifest = false
	var manifestDir = ""
	var gdunzip = load("res://vendor/gdunzip.gd").new()
	gdunzip.load(file)
	for filePath in gdunzip.files:
		var fileEntry = filePath.get_file().to_lower()
		if fileEntry.begins_with("mod") and fileEntry.ends_with(".manifest"):
			var manifestGlobalPath = "res://" + filePath
			Debug.l("Mod Menu Update Checker: Loading manifest file @ %s" % manifestGlobalPath)
			hasManifest = true
			manifestDir = manifestGlobalPath
		if fileEntry.begins_with("modmain") and fileEntry.ends_with(".gd"):
			var modGlobalPath = "res://" + filePath
			Debug.l("Mod Menu Update Checker: Loading ModMain file @ %s" % modGlobalPath)
			var modData = load_file(modGlobalPath, file, hasManifest, manifestDir)
			if modGlobalPath != null:
				return modData
			else:
				return null

func load_file(modDir, zipDir, hasManifest, manifestDirectory):
	var dirSplit = zipDir.split("/")
	var dirSplitSize = dirSplit.size()
	var fallbackDir = dirSplit[dirSplitSize - 1]
	var f = File.new()
	var manifestVersion = ""
	var manifestID = ""
	if hasManifest:
		f.open(manifestDirectory, File.READ)
		var manifestData = loadManifestFromFile(manifestDirectory)
		manifestVersion = manifestData["package"]["version"]
		manifestID = manifestData["package"]["id"]
		f.close()
	f.open(modDir, File.READ)
	var modVer = ""
	var verCheck = 0
	var content = f.get_as_text(true)
	var modMainLines = content.split("\n")
	for l in modMainLines:
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
	var ver = ""
	if verCheck == 1:
		ver = modVer
	else:
		ver = "unknown"
	var verData = String(ver)
	var modData = manifestID + "\n" + verData
	return modData
	
	
	
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

func loadStaticPersistFile():
	var saveHandle = File.new()
	saveHandle.open(persistFileStatic, File.READ)
	var saveDict = parse_json(saveHandle.get_line())
	saveHandle.close()
	hasFetchedValidMods = true
	return saveDict
	
func deletePersistFile():
	var dir = Directory.new()
	dir.remove(persistFile)
