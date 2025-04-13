extends Button

var Globals = preload("res://ModMenu/Globals.gd").new()
var cfg = "user://cfg/"

func _on_ClearCFG_pressed():
	var files = Globals.__fetch_folder_files(cfg)
	var dir = Directory.new()
	dir.open(cfg)
	for file in files:
		dir.remove(file)
