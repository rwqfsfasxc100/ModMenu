extends Label



func _on_ConflictInfo_visibility_changed():
	pass
	var cacheDir = "user://cache/.Mod_Menu_Cache/conflicts/conflicts.modmenucache"
	var currentData = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().editor_description
	var file = File.new()
	file.open(cacheDir, File.READ)
	var data = file.get_as_text()
	file.close()
	var spl = data.split("\n")
	for split in spl:
		var splitA = split.split("|~")
		var splitB = splitA[0].split("~|")
		if splitB[1] == currentData.split("\n")[0]:
			text = splitA[1]
#	var updateDir = "user://cache/.Mod_Menu_Cache/updatecache/mod.updates"
#	var currentData = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().editor_description
#	var file = File.new()
#	file.open(updateDir, File.READ)
#	var data = file.get_as_text()
#	file.close()
#
#	var mods = data.split("\n")
#	var currentMod = currentData.split("\n")
#	for mod in mods:
#		var mdata = mod.split("~||~")
#		if mdata[2] > currentMod[4] and mdata[0] == currentMod[15]:
#			text = TranslationServer.translate("MODMENU_CONFLICT_NOTIFICATION_TEXT") % [currentData.split("\n")[0],mdata[2],currentData.split("\n")[4]]
