extends Button



func _on_GithubUpdate_pressed():
	var currentData = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().editor_description
	var modID = str(currentData.split("\n")[15])
	var cacheExtension = ".modmenucache"
	var zipStore = "user://.Mod_Menu_Cache/updatecache/downloaded_zips/github_data/" + modID + cacheExtension
	var file = File.new()
	file.open(zipStore, File.READ)
	var data = file.get_as_text()
	file.close()
	var url = data.split("\n")[1]
	Achivements.openUrl(url)
	OS.shell_open(getGameInstallDirectory() + "/mods/")
	
	var process = OS.get_process_id()
	OS.kill(process)




func getGameInstallDirectory():
	var exe = OS.get_executable_path().get_base_dir().replace("\\", "/")
	match OS.get_name():
		"OSX":
			exe += "/../../.."
	return exe


func _on_GithubUpdate_visibility_changed():
	var updatePrefs = Settings.ModMenu["mainSettings"]["updatePrefs"]
	if not updatePrefs == 0:
		self.remove_and_skip() 
