extends Node

static func get_file_content(file):
	var n = File.new()
	n.open(file, File.READ)
	var s = n.get_as_text()
	n.close()
	return s
	
