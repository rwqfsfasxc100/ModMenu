extends Node

static func get_zip_content(path, stripFolder = false, lowerCase = false):
	var listOfNames = []
	var gdunzip = load("res://vendor/gdunzip.gd").new()
	gdunzip.load(path)
	var fileList = gdunzip.files
	for m in fileList.keys():
		if stripFolder:
			var delim = m.split("/")[0] + "/"
			var s = m.split(delim)
			m = s[1]
		if lowerCase:
			m = m.to_lower()
		listOfNames.append(m)
		
	return listOfNames
