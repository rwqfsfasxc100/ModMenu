extends HTTPRequest

var Globals = preload("res://ModMenu/Globals.gd").new()
var slatedForUpdateCacheFolder = "user://.Mod_Menu_Cache/updatecache/current_mod_caches/"
var githubDataCache = "user://.Mod_Menu_Cache/updatecache/github_cache/"
var persistUpdateCacheFolder = "user://.Mod_Menu_Cache/updatecache/persistent_mod_caches/"
var zipStore = "user://.Mod_Menu_Cache/updatecache/downloaded_zips/"

func _on_zip_request_completed(result, response_code, headers, body):
	
	var e = get_parent().get_node("ZipDownloadHandler").get_download_file()
	var firstFile = Globals.__get_first_file(slatedForUpdateCacheFolder)
	var firstPersist = Globals.__get_first_file(persistUpdateCacheFolder)
	if firstFile:
		var directory = Directory.new()
		directory.open(slatedForUpdateCacheFolder)
		directory.remove(firstFile)
	var files = Globals.__fetch_folder_files(slatedForUpdateCacheFolder)
	if files == []:
		get_parent().get_node("handleDownloadedZips").handleZips()
	else:
		get_parent().get_node("ReleasesURLHandler").start_process()
