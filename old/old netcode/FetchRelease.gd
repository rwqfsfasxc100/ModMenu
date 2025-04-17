extends HTTPRequest

var validMods
var fileCacheDir = "user://cache/.Mod_Menu_Cache/mod_update_cache/"
var tempFolderPath = "user://cache/.Mod_Menu_Cache/"
var cacheExtension = ".modmenucache"
var cacheFolderPath = "mod_update_cache/"
var persistFile = tempFolderPath + cacheFolderPath + "persist.current" + cacheExtension


func _ready():
	pass

func _on_FetchRelease_request_completed(result, response_code, headers, body):
	validMods = loadPersistFile()
	if validMods == {} or validMods == null or validMods == 0:
		return null
	else:
		compareCaches()
	var keys = validMods.keys()
	if keys.size() == 0:
		return
	else:
		validMods.erase(keys[0])
	savePersistFile(validMods)

	get_parent().get_parent().get_parent().getGithubAssetData()

func savePersistFile(dict):
	var saveHandle = File.new()
	saveHandle.open(persistFile, File.WRITE)
	saveHandle.store_line(to_json(dict))
	saveHandle.close()

func loadPersistFile():
	var saveHandle = File.new()
	saveHandle.open(persistFile, File.READ)
	var saveDict = parse_json(saveHandle.get_line())
	saveHandle.close()
	return saveDict

func deletePersistFile():
	var dir = Directory.new()
	dir.remove(persistFile)

func saveCacheFile(content):
	if not content == "":
		var modCacheFileName = tempFolderPath + cacheFolderPath + validMods.keys()[0] + cacheExtension
		var modCacheUpdate = File.new()
		modCacheUpdate.open(modCacheFileName, File.WRITE)
		modCacheUpdate.store_string(content)
		modCacheUpdate.close()

func loadCacheFile():
	var modCacheFileName = tempFolderPath + cacheFolderPath + validMods.keys()[0] + cacheExtension
	var modCacheUpdate = File.new()
	modCacheUpdate.open(modCacheFileName, File.READ)
	var content = modCacheUpdate.get_as_text()
	modCacheUpdate.close()
	return content



func compareCaches():
	var keys = validMods.keys()
	var currentMod = keys[0]
	var modData = validMods.get(currentMod)
	var modVer = modData[3]
	var cache = loadCacheFile()
	var lastModVer = cache.split("\n")[0]
	
	saveCacheFile(modVer + "\n" + Time.get_datetime_string_from_system(true) + "\n" + modData[1])
	
