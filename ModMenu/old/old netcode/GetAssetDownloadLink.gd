extends HTTPRequest

onready var nodeData = get_parent().editor_description

var fileCacheDir = "user://cache/.Mod_Menu_Cache/mod_update_cache/"
var fileStoreDir = "user://cache/.Mod_Menu_Cache/mod_zip_cache/"
var tempFolderPath = "user://cache/.Mod_Menu_Cache/"
var cacheExtension = ".modmenucache"
var cacheFolderPath = "mod_update_cache/"
var persistFile = tempFolderPath + cacheFolderPath + "persist.current" + cacheExtension

var releaseURL

func _ready():
	pass

func _on_GetAssetDownloadLink_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var releasesContent
	if not json.result == null:
		releasesContent = json.result
	var cycle = 0
	if not releasesContent == null:
		for n in releasesContent:
			if cycle == 0:
				releaseURL = n["browser_download_url"]
				editor_description = n["browser_download_url"]
				cycle += 1
	editor_description = releaseURL
	download(releaseURL, fileStoreDir + releaseURL.split("/")[releaseURL.split("/").size() - 1])

func download(link, path):
	if link == "DOES_NOT_EXIST":
		return "DOES_NOT_EXIST"
	$FetchRelease.set_download_file(path)
	$FetchRelease.request(link)
