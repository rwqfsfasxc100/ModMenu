extends Node

var Globals = preload("res://ModMenu/Globals.gd").new()

var cacheExtension = ".modmenucache"
var slatedForUpdateCacheFolder = "user://.Mod_Menu_Cache/current_mod_caches/"
var persistUpdateCacheFolder = "user://.Mod_Menu_Cache/persistent_mod_caches/"
var debugPrefix = "Mod Menu Update Checker: "

func _ready():
	var v = Globals.__check_folder_exists(slatedForUpdateCacheFolder)
	if not v:
		Debug.l("%s Failed to create update temp folder" % debugPrefix)
		Debug.l("%s Please check folder permissions for the save folder" % debugPrefix)
		Debug.l("%s Exiting" % debugPrefix)
		return
	var d = Globals.__check_folder_exists(persistUpdateCacheFolder)
	if not d:
		Debug.l("%s Failed to create update temp folder" % debugPrefix)
		Debug.l("%s Please check folder permissions for the save folder" % debugPrefix)
		Debug.l("%s Exiting" % debugPrefix)
		return
	startHandlingMods()
	$ReleasesURLHandler.start_process()

func startHandlingMods():
	var maxMods = get_parent().get_node("VBoxContainer").get_child_count()
	var validMods = get_parent().get_node("InstalledModsWithValidIDs").editor_description.split("\n")
	var modCount = validMods.size()
	if modCount > maxMods:
		return
	for m in validMods:
		if not m == null:
			var modInfo = str(m).split("~||~")
			if modInfo.size() <=3:
				return
			if not modInfo[3] == "MODMENU_GITHUB_RELEASES_PLACEHOLDER":
				var file = File.new()
				file.open(slatedForUpdateCacheFolder + modInfo[0] + cacheExtension, File.WRITE)
				file.store_string(m)
				file.close()
				var filePersist = File.new()
				filePersist.open(persistUpdateCacheFolder + modInfo[0] + cacheExtension, File.WRITE)
				filePersist.store_string(m)
				filePersist.close()
