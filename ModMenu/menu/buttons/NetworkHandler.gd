extends Node2D

var tempFolderPath = "user://.Mod_Menu_Cache/"
var cacheFolderPath = "mod_update_cache/"
onready var nodeData = get_parent().editor_description.split("\n")
onready var githubReleasesURL = nodeData[7]
#onready var forceUpdateCheck = Settings.ModMenu["debugStuffNotForTheSeeingEyes"]["forceUpdateCheck"]
onready var forceUpdateCheck = false
#onready var getLastUpdateTime = Settings.ModMenu["debugStuffNotForTheSeeingEyes"]["lastUpdateCheckPerformedAt"]
onready var getLastUpdateTime = "2001-09-11T09:18:20"
#onready var offsetVal = Settings.ModMenu["mainSettings"]["updateCheckerDelay"]
onready var offsetVal = 3

onready var latestModVersion = nodeData[4]
var hasUpdate = false
var cacheExtension = ".modmenucache"


func _ready():
	writeInitialEditorText()
	checkTempFolderExists()
	var lastDict = Time.get_datetime_dict_from_datetime_string(getLastUpdateTime, false)
	var dictWithOffset = setOffsetForTimestamp(lastDict)
	var dictWithOffsetString = timeStringConcat(Time.get_datetime_string_from_datetime_dict(dictWithOffset, false))
	var currentTimeString = timeStringConcat(Time.get_datetime_string_from_system(true))
	if dictWithOffsetString <= currentTimeString:
		var assetStr = getGithubAssetData()
		
		
		if assetStr == "DOES_NOT_EXIST":
			pass
		if not assetStr == "DOES_NOT_EXIST": 
			var resourceStr = getGithubReleaseData(assetStr)
			if resourceStr == "DOES_NOT_EXIST":
				pass
		else:
			var releaseStr = "DOES_NOT_EXIST"
		

func getGithubAssetData():
	var urlSplitByGithub = githubReleasesURL.split("https://github.com/")
	var urlSplitByReleases = urlSplitByGithub[1].split("/releases")
	var githubApiURL = "https://api.github.com/repos/" + urlSplitByReleases[0] + "/releases"
	var assetURL = $GetLatestValidRelease.request(githubApiURL)
	
	if not assetURL == "DOES_NOT_EXIST":
		return assetURL
	else:
		return "DOES_NOT_EXIST"

func getGithubReleaseData(assetURL):
	if assetURL == "DOES_NOT_EXIST":
		return "DOES_NOT_EXIST"
	var releaseURL = $GetAssetDownloadLink.request(assetURL)
	if not releaseURL == "DOES_NOT_EXIST":
		return releaseURL
	else:
		return "DOES_NOT_EXIST"



func loadCacheFile():
	var modCacheFileName = tempFolderPath + cacheFolderPath + nodeData[3] + cacheExtension
	var modCacheUpdate = File.new()
	var assetURL = "DOES_NOT_EXIST"
	var releaseURL = "DOES_NOT_EXIST"
	modCacheUpdate.open(modCacheFileName, File.READ)
	var doesCacheFileExist = modCacheUpdate.file_exists(modCacheFileName)
	if not doesCacheFileExist:
		saveCacheFile(assetURL + "\n" + releaseURL + "\n" + latestModVersion)
		modCacheUpdate.open(modCacheFileName, File.READ)
	var content = modCacheUpdate.get_as_text()
	modCacheUpdate.close()
	return content


func saveCacheFile(content):
	if not content == "":
		var modCacheFileName = tempFolderPath + cacheFolderPath + nodeData[3] + cacheExtension
		var modCacheUpdate = File.new()
		modCacheUpdate.open(modCacheFileName, File.WRITE)
		modCacheUpdate.store_string(content)
		modCacheUpdate.close()



func writeInitialEditorText():
	var modCache = loadCacheFile().split("\n")
	var assetURL = "DOES_NOT_EXIST"
	var releaseDownloadURL = "DOES_NOT_EXIST"
	if modCache[0] == "DOES_NOT_EXIST":
		assetURL = getGithubAssetData()
	if modCache[1] == "DOES_NOT_EXIST":
		releaseDownloadURL = getGithubReleaseData(assetURL)
	editor_description = assetURL + "\n" + releaseDownloadURL + "\n" + latestModVersion
	pass

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

func getMonthDaySubtract(checkMonth, checkYear):
	if checkMonth == 2:
		if checkYear % 4 == 0:
			return 3
		else:
			return 2
	elif checkMonth >= 1 and checkMonth <= 7 and checkMonth % 2 == 1:
		return 0
	elif checkMonth >= 8 and checkMonth <= 12 and checkMonth % 2 == 0:
		return 0
	else:
		return 1

func timeStringConcat(timeValue):
	var splitDateAndTime = timeValue.split("T")
	var splitDate = splitDateAndTime[0].split("-")
	var splitTime = splitDateAndTime[1].split(":")
	var patchDate = splitDate[0] + splitDate[1] + splitDate[2] + splitTime[0] + splitTime[1] + splitTime[2]
	return patchDate

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


