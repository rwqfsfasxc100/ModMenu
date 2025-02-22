extends Label

var modDependancy = []
var modCount = 0

func _ready():
	grow_horizontal = 0
	getModCount()
	self.text = "%s Mod(s) Installed" % modCount
	
func getModCount():
	var gameInstallDirectory = OS.get_executable_path().get_base_dir()
	if OS.get_name() == "OSX":
		gameInstallDirectory = gameInstallDirectory.get_base_dir().get_base_dir().get_base_dir()
	var modPathPrefix = gameInstallDirectory.plus_file("mods")
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
		modDependancy.append(fileName)
		
	for mod in modDependancy:
		modCount += 1

