extends Button

var Globals = preload("res://ModMenu/Globals.gd").new()

func _on_OpenFolder_pressed():
	
	var files = Globals.__fetch_folder_files("user://.Mod_Menu_Cache/updated_zips")
	for file in files:
		var dir = Directory.new()
		dir.remove("user://.Mod_Menu_Cache/updated_zips/" + file)
		
	
	var currentData = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().editor_description
	var modID = str(currentData.split("\n")[15])
	var cacheExtension = ".modmenucache"
	var zipStore = "user://.Mod_Menu_Cache/downloaded_zips/github_data/" + modID + cacheExtension
	var file = File.new()
	file.open(zipStore, File.READ)
	var data = file.get_as_text()
	file.close()
	
	
	var updateZipFolder = "user://.Mod_Menu_Cache/updated_zips/"
	Globals.__check_folder_exists(updateZipFolder)
	var zipToCopy = "user://.Mod_Menu_Cache/downloaded_zips/" + data.split("\n")[2]
	var dir = Directory.new()
	dir.copy(zipToCopy, updateZipFolder + data.split("\n")[2])
	var hasWindows = OS.has_feature("Windows")
	var hasLinux = OS.has_feature("X11")
	var hasOSX = OS.has_feature("OSX")
	var updateFolder = OS.get_user_data_dir()# + ".Mod_Menu_Cache/updated_zips/"
	var suffix = "/.Mod_Menu_Cache/updated_zips/"
	OS.shell_open(updateFolder + suffix) 
	
	var file2 = File.new()
	file2.open(zipStore, File.READ)
	var data2 = file2.get_as_text()
	file.close()
	var url = data2.split("\n")[1]
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


func _on_OpenFolder_visibility_changed():
	var updatePrefs = Settings.ModMenu["mainSettings"]["updatePrefs"]
	if not updatePrefs == 2:
		self.remove_and_skip() 
