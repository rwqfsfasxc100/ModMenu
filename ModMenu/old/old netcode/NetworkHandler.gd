extends Node2D



#
#
# NOTE FOR FUTURE ME:
# Defer all working code to child classes
# This script's purpose is likely best being
# changed to getting the initial dictionary and
# passing it to child node
#
#


var cacheExtension = ".modmenucache"
var tempFolderPath = "user://cache/.Mod_Menu_Cache/"
var cacheFolderPath = "mod_update_cache/"
var persistFileStatic = tempFolderPath + cacheFolderPath + "persist" + cacheExtension
var persistFile = tempFolderPath + cacheFolderPath + "persist.current" + cacheExtension

#onready var forceUpdateCheck = Settings.ModMenu["debugStuffNotForTheSeeingEyes"]["forceUpdateCheck"]
onready var forceUpdateCheck = false
#onready var offsetVal = Settings.ModMenu["mainSettings"]["updateCheckerDelay"]
onready var offsetVal = 3

onready var validMods = get_parent().get_node("MarginContainer/ScrollContainer/VBoxContainer").manifestDict

onready var keys = validMods.keys()
onready var mod = keys[0]
onready var modData = validMods.get(mod)
onready var githubReleasesURL = modData[5]


func _ready():
	blankOutUpdateCache()
	saveStaticPersistFile(validMods)
	savePersistFile(validMods)
	saveInstalledCountToFile()
	getGithubAssetData()
	


func setOffsetForTimestamp(dict):
	var currentDay = Time.get_datetime_dict_from_system(true)
	var checkMonth = dict["month"]
	var checkYear = dict["year"]
	var daySubtract = getMonthDaySubtract(checkMonth, checkYear)

	if offsetVal == 0:
		if dict["hour"] >=24:
			dict["day"] += 1
			dict["hour"] -= 24
		dict["hour"] += 1

	if offsetVal == 1:
		if dict["hour"] >=24:
			dict["day"] += 1
			dict["hour"] -= 24
		dict["hour"] += 4

	if offsetVal == 2:
		if dict["hour"] >=24:
			dict["day"] += 1
			dict["hour"] -= 24
		dict["hour"] += 12

	if offsetVal == 3:
		if dict["day"] + daySubtract >= 31:
			dict["month"] += 1
			dict["day"] -= (31 - daySubtract)
		dict["day"] += 1

	if offsetVal == 4:
		if dict["day"] + daySubtract >= 31:
			dict["month"] += 1
			dict["day"] -= (31 - daySubtract)
		dict["day"] += 3

	if offsetVal == 5:
		if dict["day"] + daySubtract >= 31:
			dict["month"] += 1
			dict["day"] -= (31 - daySubtract)
		dict["day"] += 7

	if offsetVal == 6:
		if dict["day"] + daySubtract >= 31:
			dict["month"] += 1
			dict["day"] -= (31 - daySubtract)
		dict["day"] += 14

	if offsetVal == 7:
		dict["year"] = 9999

	return dict


func timeStringConcat(timeValue):
	var splitDateAndTime = timeValue.split("T")
	var splitDate = splitDateAndTime[0].split("-")
	var splitTime = splitDateAndTime[1].split(":")
	var patchDate = splitDate[0] + splitDate[1] + splitDate[2] + splitTime[0] + splitTime[1] + splitTime[2]
	return patchDate

func getGithubAssetData():
	
	$GetLatestValidRelease.checkIfTime()


func getMonthDaySubtract(checkMonth, checkYear):
	if checkMonth == 2:
		if checkYear % 4 == 0:
			return 2
		else:
			return 3
	elif checkMonth >= 1 and checkMonth <= 7 and checkMonth % 2 == 1:
		return 0
	elif checkMonth >= 8 and checkMonth <= 12 and checkMonth % 2 == 0:
		return 0
	else:
		return 1


func loadCacheFile():
	var validMods = get_parent().get_node("MarginContainer/ScrollContainer/VBoxContainer").manifestDict
	var keys = validMods.keys()
	var mod = keys[0]
	var modData = validMods.get(mod)
	var modCacheFileName = tempFolderPath + cacheFolderPath + validMods.keys()[0] + cacheExtension
	var modCacheUpdate = File.new()
	modCacheUpdate.open(modCacheFileName, File.READ)
	var doesCacheFileExist = modCacheUpdate.file_exists(modCacheFileName)
	if not doesCacheFileExist:
		saveCacheFile(modData[3] + "\n" + Time.get_datetime_string_from_system(true) + "\n" + modData[1])
		modCacheUpdate.open(modCacheFileName, File.READ)
	var content = modCacheUpdate.get_as_text()
	modCacheUpdate.close()
	return content

func saveCacheFile(content):
	if not content == "":
		var validMods = get_parent().get_node("MarginContainer/ScrollContainer/VBoxContainer").manifestDict
		var keys = validMods.keys()
		var mod = keys[0]
		var modData = validMods.get(mod)
		var modCacheFileName = tempFolderPath + cacheFolderPath + validMods.keys()[0] + cacheExtension
		var modCacheUpdate = File.new()
		modCacheUpdate.open(modCacheFileName, File.WRITE)
		modCacheUpdate.store_string(content)
		modCacheUpdate.close()

func checkIfAcceptable(n):
	if n["draft"]:
		return false
	if n["prerelease"]:
		if forceUpdateCheck:
			return true
		else:
			return false
	else:
		return true

func checkTempFolderExists(): 
	var directory = Directory.new()
	if directory.dir_exists(tempFolderPath + cacheFolderPath):
		Debug.l("Temp mod menu directory exists")
	else:
		var error_code = directory.make_dir_recursive(tempFolderPath + cacheFolderPath)
		if error_code != OK:
			Debug.l("Failed to make temp folder")

func saveStaticPersistFile(dict):
	var saveHandle = File.new()
	saveHandle.open(persistFileStatic, File.WRITE)
	saveHandle.store_line(to_json(dict))
	saveHandle.close()

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

func saveInstalledCountToFile():
	var installedModCount = loadPersistFile().keys().size()
	var file = File.new()
	file.open(tempFolderPath + cacheFolderPath + "instlledModCount" + cacheExtension, File.WRITE)
	file.store_line(str(installedModCount))
	file.close()

func blankOutUpdateCache():
	var filePath = tempFolderPath + cacheFolderPath + "modsSlatedForUpdate" + cacheExtension
	var file = File.new()
	file.open(filePath, File.WRITE)
	file.store_string("")
	file.close()







# Comment Hell

# Pretty much all code made before the current iteration
# Is very disorganized as it's before I realized that
# Godot has to do all the HTTP requests in sequence,
# rather than in parallel via an instanced node for
# every compatable mod

# Might be useful for some people (?????, really idk)



#onready var nodeData = get_parent().editor_description.split("\n")
#onready var githubReleasesURL = nodeData[7]
#onready var forceUpdateCheck = Settings.ModMenu["debugStuffNotForTheSeeingEyes"]["forceUpdateCheck"]
#onready var forceUpdateCheck = false
#onready var getLastUpdateTime = Settings.ModMenu["debugStuffNotForTheSeeingEyes"]["lastUpdateCheckPerformedAt"]
#onready var getLastUpdateTime = "2001-09-11T09:18:20"
#onready var offsetVal = Settings.ModMenu["mainSettings"]["updateCheckerDelay"]
#onready var offsetVal = 3
#
#onready var latestModVersion = nodeData[4]
#var hasUpdate = false
#var cacheExtension = ".modmenucache"


#func _ready():
#	writeInitialEditorText()
#	checkTempFolderExists()
#	var lastDict = Time.get_datetime_dict_from_datetime_string(getLastUpdateTime, false)
#	var dictWithOffset = setOffsetForTimestamp(lastDict)
#	var dictWithOffsetString = timeStringConcat(Time.get_datetime_string_from_datetime_dict(dictWithOffset, false))
#	var currentTimeString = timeStringConcat(Time.get_datetime_string_from_system(true))
#	if dictWithOffsetString <= currentTimeString:
#		getGithubAssetData()

#func getGithubAssetData():
#	var urlSplitByGithub = githubReleasesURL.split("https://github.com/")
#	var urlSplitByReleases = urlSplitByGithub[1].split("/releases")
#	var githubApiURL = "https://api.github.com/repos/" + urlSplitByReleases[0] + "/releases"
#	$GetLatestValidRelease.checkIfTime()
#	get_parent().get_parent().get_node("AssetPages").editor_description = get_parent().get_parent().get_node("AssetPages").editor_description + githubApiURL + "\n"
# -- Plan for this to work sequentially instead of in parallel. Change things up to add a new NetworkHandler node every time the original one finishes, and implement check for releases. if releases page is found, continue, otherwise add networkhandler node to next node
