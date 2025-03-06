extends Node

static func get_mod_main(file, split_into_array = false):
	var Globals = load("res://ModMenu/Globals.gd").new()
	var hasManifest = false
	var manifestDir = ""
	var hasIcon = false
	var iconDir = ""
	var modData
	var modMainPath = ""
	var filesInZip = Globals.__get_zip_content(file)
	for m in filesInZip:
		var modPath = "res://" + m
		m = m.split(m.split("/")[0] + "/")[1].to_lower()
		if m.begins_with("mod") and m.ends_with(".manifest"):
			Debug.l("ModMenu Loader Storage: Loading manifest file @ %s" % modPath)
			hasManifest = true
			manifestDir = modPath
		if m.begins_with("icon") and m.ends_with(".stex"):
			Debug.l("ModMenu Loader Storage: Loading manifest file @ %s" % modPath)
			hasIcon = true
			iconDir = modPath
		if m.begins_with("modmain") and m.ends_with(".gd"):
			Debug.l("ModMenu Loader Storage: Loading ModMain file @ %s" % modPath)
			modData = Globals.__load_file(modPath, file, hasManifest, manifestDir, hasIcon, iconDir)
			modMainPath = modPath
	if split_into_array:
		modData = modData.split("\n")
	if modMainPath != null:
		return modData
	else:
		return null
