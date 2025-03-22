extends Button



func _on_OpenCache_pressed():
	var updateFolder = OS.get_user_data_dir()# + ".Mod_Menu_Cache/updated_zips/"
	var suffix = "/.Mod_Menu_Cache/"
	OS.shell_open(updateFolder + suffix) 
