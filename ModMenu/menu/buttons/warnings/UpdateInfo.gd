extends Label

func _on_UpdateInfo_visibility_changed():
	var updateDir = "user://.Mod_Menu_Cache/mod.updates"
	var currentData = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().editor_description
	var file = File.new()
	file.open(updateDir, File.READ)
	var data = file.get_as_text()
	file.close()
	
	var mods = data.split("\n")
	var currentMod = currentData.split("\n")
	for mod in mods:
		var mdata = mod.split("~||~")
		if mdata[2] > currentMod[4] and mdata[0] == currentMod[15]:
			text = TranslationServer.translate("MODMENU_UPDATE_NOTIFICATION_TEXT") % [currentData.split("\n")[0],mdata[2],currentData.split("\n")[4]]
