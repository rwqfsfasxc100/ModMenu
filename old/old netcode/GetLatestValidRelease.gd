extends HTTPRequest

onready var nodeData = get_parent().editor_description

#onready var offsetVal = Settings.ModMenu["mainSettings"]["updateCheckerDelay"]
onready var offsetVal = 3

# Have new function handle this, loading of the persist file should happen when called not on ready. do recursively for child node scripts


var assetURL


var validMods

var keys
var mod
var modData
var githubReleasesURL

var hasFetchedValidMods = false

#onready var forceUpdateCheck = Settings.ModMenu["debugStuffNotForTheSeeingEyes"]["forceUpdateCheck"]
onready var forceUpdateCheck = false

var cacheExtension = ".modmenucache"
var tempFolderPath = "user://cache/.Mod_Menu_Cache/"
var cacheFolderPath = "mod_update_cache/"
var persistFile = tempFolderPath + cacheFolderPath + "persist.current" + cacheExtension

func _ready():
	pass

func _on_GetLatestValidRelease_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var releasesContent
	if not json.result == null:
		releasesContent = json.result
	var cycle = 0
	if not releasesContent == null:
		for n in releasesContent:
			if cycle == 0:
				if not checkIfAcceptable(n):
					return
				assetURL = n["assets_url"]
				editor_description = n["assets_url"]
				cycle += 1
			else:
				pass
	editor_description = assetURL
	getGithubReleaseData(assetURL)


func getGithubReleaseData(URLData):
	if URLData == "DOES_NOT_EXIST":
		return "DOES_NOT_EXIST"
	$GetAssetDownloadLink.request(URLData)

var checkedMods = []

func checkIfTime():
	var installedModCount = getModCountFromFile()
	if installedModCount >= 1:
		getValidMods()
	
		var cacheData = loadCacheFile()
	
	
		var lastDict = Time.get_datetime_dict_from_datetime_string(cacheData.split("\n")[1], false)
		var dictWithOffset = setOffsetForTimestamp(lastDict)
		var dictWithOffsetString = timeStringConcat(Time.get_datetime_string_from_datetime_dict(dictWithOffset, false))
		var currentTimeString = timeStringConcat(Time.get_datetime_string_from_system(true))
		checkedMods.append(mod)
		validMods.erase(mod)
		saveInstalledCountToFile(installedModCount - 1)
		if dictWithOffsetString <= currentTimeString:
			getGitRelease()
		else:
			checkIfTime()
	else:
		var keys = validMods.keys()
		var recheck = validMods.keys()
		if recheck.size() == 0:
#			Settings.ModMenu["debugStuffNotForTheSeeingEyes"]["lastUpdateCheckPerformedAt"] = Time.get_datetime_string_from_system()
			get_parent().get_node("ZipChecker").onCall()

func getGitRelease():
	saveCurrentModProcessToFile()
	var urlSplitByGithub = githubReleasesURL.split("https://github.com/")
	var urlSplitByReleases = urlSplitByGithub[1].split("/releases")
	var githubApiURL = "https://api.github.com/repos/" + urlSplitByReleases[0] + "/releases"
	request(githubApiURL)


func timeStringConcat(timeValue):
	var splitDateAndTime = timeValue.split("T")
	var splitDate = splitDateAndTime[0].split("-")
	var splitTime = splitDateAndTime[1].split(":")
	var patchDate = splitDate[0] + splitDate[1] + splitDate[2] + splitTime[0] + splitTime[1] + splitTime[2]
	return patchDate
	
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
	hasFetchedValidMods = true
	return saveDict

func getValidMods():
	if not hasFetchedValidMods:
		validMods = loadPersistFile()
	keys = validMods.keys()
	mod = keys[0]
	modData = validMods.get(mod)
	githubReleasesURL = modData[5]



func saveInstalledCountToFile(installedModCount):
	var file = File.new()
	file.open(tempFolderPath + cacheFolderPath + "instlledModCount" + cacheExtension, File.WRITE)
	file.store_line(str(installedModCount))
	file.close()

func getModCountFromFile():
	var file = File.new()
	file.open(tempFolderPath + cacheFolderPath + "instlledModCount" + cacheExtension, File.READ)
	var content = file.get_line()
	file.close()
	return int(content)

func saveCurrentModProcessToFile():
	var filePath = tempFolderPath + cacheFolderPath + "modsSlatedForUpdate" + cacheExtension
	var fileCheck = File.new()
	fileCheck.open(filePath, File.READ)
	var content = fileCheck.get_as_text()
	fileCheck.close()
	var file = File.new()
	file.open(filePath, File.WRITE)
	file.store_string(content + mod + "\n")
	file.close()
