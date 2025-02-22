extends "res://VersionLabel.gd"

var modCount = 0
var modCountList = []

func _ready():

	var gameInstallDirectory = OS.get_executable_path().get_base_dir()
	if OS.get_name() == "OSX":
		gameInstallDirectory = gameInstallDirectory.get_base_dir().get_base_dir().get_base_dir()
	var modPathPrefix = gameInstallDirectory.plus_file("mods")
	Debug.l("Mod Menu List: Registering and verifying contents of the mods folder")
	var dir = Directory.new()
	dir.open(modPathPrefix)
	var dirName = dir.get_current_dir()
	dir.list_dir_begin(true)
	while true:
		var fileName = dir.get_next()
		dirName = dir.get_current_dir()
		Debug.l(fileName)
		if fileName == "":
			break
		if dir.current_is_dir():
			continue
		
		modCountList.append(fileName)
	for mod in modCountList:
		modCount += 1
	
	grow_horizontal = 0
	text = "ΔV %s + %s Mods Installed" % [text, modCount]
	CurrentGame.version = text
