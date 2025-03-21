extends HTTPRequest

var Globals = preload("res://ModMenu/Globals.gd").new()

var cacheExtension = ".modmenucache"
var slatedForUpdateCacheFolder = "user://.Mod_Menu_Cache/updatecache/current_mod_caches/"
var githubDataCache = "user://.Mod_Menu_Cache/updatecache/github_cache/"
var persistUpdateCacheFolder = "user://.Mod_Menu_Cache/updatecache/persistent_mod_caches/"
var zipStore = "user://.Mod_Menu_Cache/updatecache/downloaded_zips/"
var debugPrefix = "Mod Menu Update Checker: "

func start_process():
	var releaseURL = ""
	var firstFile = Globals.__get_first_file(slatedForUpdateCacheFolder)
	if firstFile:
		var content = Globals.__get_file_content(slatedForUpdateCacheFolder + firstFile)
		var splits = content.split("\n")[0].split("~||~")
		releaseURL = splits[3]
		if not releaseURL == "":
			var urlSplitByGithub = releaseURL.split("https://github.com/")
			var urlSplitByReleases = urlSplitByGithub[1].split("/releases")
			var githubApiURL = "https://api.github.com/repos/" + urlSplitByReleases[0] + "/releases"
			request(githubApiURL)

func _on_release_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var releasesContent
	var data
	if not json.result == null:
		releasesContent = json.result
	var cycle = 0
	if not releasesContent == null:
		for n in releasesContent:
			if cycle == 0:
				if not checkIfAcceptable(n):
					return
				var assets = n["assets"][0]
				var assetURL = assets["browser_download_url"]
				var releaseDate = assets["updated_at"].split("Z")[0]
				var githubTag = n["tag_name"]
				data = assetURL + "\n" + releaseDate + "\n" + githubTag
				
				var firstFile = Globals.__get_first_file(slatedForUpdateCacheFolder)
				if firstFile:
					var content = Globals.__get_file_content(slatedForUpdateCacheFolder + firstFile)
					var splits = content.split("\n")[0].split("~||~")
					Globals.__check_folder_exists(zipStore + "github_data/")
					var filen = File.new()
					filen.open(zipStore + "github_data/" + splits[0] + cacheExtension, File.WRITE)
					filen.store_string(splits[0] + "\n" + n["html_url"] + "\n" + n["assets"][0]["name"])
					filen.close()
				cycle += 1
			else:
				pass
	if not data == null:
		var firstFile = Globals.__get_first_file(slatedForUpdateCacheFolder)
		var splits
		if firstFile:
			var content = Globals.__get_file_content(slatedForUpdateCacheFolder + firstFile)
			splits = content.split("\n")[0].split("~||~")
			Globals.__check_folder_exists(githubDataCache)
			var fileSave = File.new()
			fileSave.open(githubDataCache + splits[0] + cacheExtension, File.WRITE)
			fileSave.store_string(data)
			fileSave.close()
			downloadZip(data.split("\n")[0])

func checkIfAcceptable(n):
	if n["draft"]:
		return false
	if n["prerelease"]:
		if Settings.ModMenu["mainSettings"]["updaterOption"] == 1:
			return true
		else:
			return false
	else:
		return true

func downloadZip(url):
	var check = Globals.__check_folder_exists(zipStore)
	if not check:
		return
	var zipName = url.split("/")[url.split("/").size() - 1]
	get_parent().get_node("ZipDownloadHandler").set_download_file(zipStore + zipName)
	get_parent().get_node("ZipDownloadHandler").request(url)
	
