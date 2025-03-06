extends Node

static func fetch_folder_files(folder, showFolders):
	var fileList = []
	var dir = Directory.new()
	dir.open(folder)
	var dirName = dir.get_current_dir()
	dir.list_dir_begin(true)
	while true:
		var fileName = dir.get_next()
		var capture = true
		if fileName.ends_with("/") and not showFolders:
			capture = false
		if capture:
			dirName = dir.get_current_dir()
			Debug.l(fileName)
			if fileName == "":
				break
			if dir.current_is_dir():
				continue
			fileList.append(fileName)
	
	
	
#	m = m.split(m.split("/")[0] + "/")[1].to_lower()
	
	return fileList
