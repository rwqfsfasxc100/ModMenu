extends Button

var currentlyInstalledMods

func _ready():
	self.visible = false
	

func _on_visibility_changed():
	if visible == true:
		if get_parent().is_visible_in_tree():
			get_child(0).get_node("AnimationPlayer").play("Blink")
		currentlyInstalledMods = get_parent().get_parent().get_parent().get_parent().get_node("InstalledModsWithValidIDs").editor_description
		checkForConflictsFile()
	else :
		get_child(0).get_node("AnimationPlayer").stop()


var conflictsFiles = []

func checkForConflictsFile():
	var modFolder = "res://" + get_parent().get_parent().get_parent().editor_description[3]
	var dir = Directory.new()
	dir.open(modFolder)
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
		var modFSPath = modFolder.plus_file(fileName)
		var modGlobalPath = ProjectSettings.globalize_path(modFSPath)
		if not ProjectSettings.load_resource_pack(modGlobalPath, true):
			Debug.l("Mod Menu List: %s failed to register." % fileName)
			continue
		conflictsFiles.append(fileName)
		Debug.l("Mod Menu List: %s registered." % fileName)
	
	for path in conflictsFiles:
		
		var fileEntry = path.get_file().to_lower()
		if fileEntry.begins_with("conflicts") and fileEntry.ends_with(".cfg") and name == "CONFLICTBUTTON":
			checkConflicts(fileEntry)
		if fileEntry.begins_with("dependancies") and fileEntry.ends_with(".cfg") and name == "MISSINGDEPSBUTTON":
			checkDependancies(fileEntry)
	
func checkDependancies(file):
	var depsFile = File.new()
	depsFile.open(file, File.READ)
	var content = depsFile.get_as_text().to_lower()
	depsFile.close()

func checkConflicts(file):
	var conflictFile = File.new()
	conflictFile.open(file, File.READ)
	var content = conflictFile.get_as_text().to_lower()
	conflictFile.close()


