extends Label



func _on_ConflictInfo_visibility_changed():
	pass
	var cacheDir = "user://cache/.Mod_Menu_Cache/conflicts/dependancies.modmenucache"
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
