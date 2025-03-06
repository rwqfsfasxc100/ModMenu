extends Node

static func get_first_file(folder):
	var firstFile
	var Globals = preload("res://ModMenu/Globals.gd").new()
	var fileNo = 0
	var fileList = Globals.__fetch_folder_files(folder)
	for file in fileList:
		if fileNo == 0:
			firstFile = file
			fileNo = 1
	if firstFile == null:
		return false
	else:
		return firstFile
