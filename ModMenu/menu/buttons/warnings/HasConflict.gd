extends Button

var Globals = preload("res://ModMenu/Globals.gd").new()

var currentlyInstalledMods

var conflictCacheDir = "user://.Mod_Menu_Cache/conflicts/"

func _ready():
	self.visible = false
	

#func _on_visibility_changed():
#	if visible == true:
#		if get_parent().is_visible_in_tree():
#			get_child(0).get_node("AnimationPlayer").play("Blink")
#		currentlyInstalledMods = get_parent().get_parent().get_parent().get_parent().get_node("InstalledModsWithValidIDs").editor_description
#		checkForConflictsFile()
#	else :
#		get_child(0).get_node("AnimationPlayer").stop()


var conflictsFiles = []
var lowerCase = []

func checkForConflictsFile(nodeName, parent):
	var modFolder = "res://" + parent.editor_description.split("\n")[3]
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
		conflictsFiles.append(fileName)
		lowerCase.append(fileName.to_lower())
		Debug.l("Mod Menu List: %s registered." % fileName)
	getCurrentMods(parent)
	if lowerCase.has("conflicts.cfg") or lowerCase.has("dependancies.cfg"):
		for path in conflictsFiles:
			var fileEntry = path.get_file().to_lower()
			if fileEntry.begins_with("conflicts") and fileEntry.ends_with(".cfg") and nodeName == "CONFLICTBUTTON":
				var f = checkConflicts(path, false, parent)
				if f == "hasConflict":
					return f
			if fileEntry.begins_with("dependancies") and fileEntry.ends_with(".cfg") and nodeName == "MISSINGDEPSBUTTON":
				var f = checkConflicts(path, true, parent)
				if f == "hasDeps":
					return f

var validModDisctionary = {}

func getCurrentValidMods():
	var file = File.new()
	file.open("user://.Mod_Menu_Cache/conflicts/validmods.modmenucache", File.READ)
	var textData = file.get_as_text()
	file.close()
	if not textData == "":
		var json = JSON.parse(file.get_as_text())
		validModDisctionary = json.result
	

var currentMods = []

func getCurrentMods(parent):
	var registeredMods = parent.get_parent().get_children()
	for child in registeredMods:
		var data = child.editor_description.split("\n")
		var modData = data[15] + "~||~" + data[0] + "~||~" + data[1] + "~||~" + data[4]
		currentMods.append(modData)

var triggeredMods = {}
var depMods = {}
var conflictsForDisplay = {}
var depsForDisplay = {}
var loopCount = ""
func checkConflicts(file, invert, parent):
	var modFolder = "res://" + parent.editor_description.split("\n")[3]
	file = modFolder + "/" + file
	var conflictFile = File.new()
	conflictFile.open(file, File.READ)
	var json = JSON.parse(conflictFile.get_as_text())
	var content = json.result
	conflictFile.close()
	for m in content:
		var data = content.get(m)
		if str(m).begins_with("~|") and str(m).ends_with("|~"):
			var pData = content.get(m)
			var dList = pData.values()
			var dataArray = dList.size()/5
			var isEven = dList.size()%5
			if not isEven == 0:
				break
			var operations = dataArray
			var line = 0
			var dc = {}
			while operations > 0:
				var dir = {operations:[dList[0 + (line * 5)], dList[1 + (line * 5)], dList[2 + (line * 5)], dList[3 + (line * 5)], dList[4 + (line * 5)]]}
				line += 1
				operations -= 1
				dc.merge(dir)
			
			var doesConflict = false
			for p in dc:
				var sp = dc.get(p)
				var id = sp[0]
				var name = sp[1]
				var zip = sp[2]
				var minVersion = sp[3]
				var maxVersion = sp[4]
				var triggers = compareToInstalledMods(id, name, zip, minVersion, maxVersion, invert)
				if triggers and not invert:
					triggeredMods.merge(triggers)
				elif triggers and invert:
					depMods.merge(triggers)
				
		else:
			var pData = content.get(m)
			var id = pData.get("id")
			var name = pData.get("name")
			var zip = pData.get("zip")
			var minVersion = pData.get("minVersion")
			var maxVersion = pData.get("maxVersion")
			var triggers = compareToInstalledMods(id, name, zip, minVersion, maxVersion, invert)
			if triggers and not invert:
				triggeredMods.merge(triggers)
			elif triggers and invert:
				depMods.merge(triggers)
	depsForDisplay.merge(depMods)
	conflictsForDisplay.merge(triggeredMods)
	if conflictsForDisplay.size() >= 1:
		saveConflictsToFile(parent, conflictsForDisplay)
		return "hasConflict"
	if depsForDisplay.size() >= 1:
		saveDepsToFile(parent, depsForDisplay)
		return "hasDeps"

func saveConflictsToFile(parent, conflictDict):
	var conflictNames = ""
	for p in conflictDict:
		var ls = conflictDict.get(p)
		if conflictNames == "":
			conflictNames = ls[1]
		else:
			conflictNames = conflictNames + ", " + ls[1]
	var modName = parent.editor_description.split("\n")[0]
	Globals.__check_folder_exists(conflictCacheDir)
	var file = File.new()
	file.open(conflictCacheDir + "conflicts.modmenucache", File.READ_WRITE)
	var textF = file.get_as_text()
	if textF == "":
		textF = "~|" + modName + "|~" + TranslationServer.translate("MODMENU_CONFLICT_MOD_TEXT") % [modName, conflictNames]
	else:
		textF = textF + "\n" + "~|" + modName + "|~" + TranslationServer.translate("MODMENU_CONFLICT_MOD_TEXT") % [modName, conflictNames]
	file.store_string(textF)
	file.close()
	

func saveDepsToFile(parent, conflictDict):
	var conflictNames = ""
	for p in conflictDict:
		var ls = conflictDict.get(p)
		if conflictNames == "":
			conflictNames = ls[1]
		else:
			conflictNames = conflictNames + ", " + ls[1]
	var modName = parent.editor_description.split("\n")[0]
	Globals.__check_folder_exists(conflictCacheDir)
	var file = File.new()
	file.open(conflictCacheDir + "dependancies.modmenucache", File.READ_WRITE)
	var textF = file.get_as_text()
	if textF == "":
		textF = "~|" + modName + "|~" + TranslationServer.translate("MODMENU_DEPS_MOD_TEXT") % [modName, conflictNames]
	else:
		textF = textF + "\n" + "~|" + modName + "|~" + TranslationServer.translate("MODMENU_DEPS_MOD_TEXT") % [modName, conflictNames]
	file.store_string(textF)
	file.close()
	
func compareToInstalledMods(id, name, zip, minVersion, maxVersion, invert):
	var modDict = {}
	var modCounter = 0
	for mods in currentMods:
		var modsArray = mods.split("~||~")
		var dict = {modCounter:modsArray}
		modDict.merge(dict)
		modCounter += 1
	
	
	for p in modDict:
		var mod = modDict.get(p)
		var newID = mod[0]
		var newName = mod[1]
		var newZip = mod[2]
		var newVer = mod[3]
		var triggers = false
		if newID == id:
			triggers = true
		if newName == name or newName == zip:
			triggers = true
		if newZip == zip:
			triggers = true
		if triggers:
			if not invert:
				var consideredConflict = false
				if triggers:
					var check
					if checkForNull(newVer) == "any":
						consideredConflict = true
					else:
						var afterMinimum = false
						var minimum = checkForNull(minVersion)
						if minimum == "any":
							afterMinimum = true
						elif newVer >= minimum:
							afterMinimum = true
						var beforeMaximum = false
						var maximum = checkForNull(maxVersion)
						if maximum == "any":
							beforeMaximum = true
						elif newVer <= maximum:
							beforeMaximum = true
						if beforeMaximum or afterMinimum:
							consideredConflict = true
				if consideredConflict and not triggeredMods.has(zip):
					loopCount = zip
					return {loopCount:[newID, newName, newZip, newVer]}
				else:
					return false
			else:
				# Write inversion code for dependancy checking
				# This code currently mirrors conflicts
				# Perhaps instead of checking for conflict, start with dependancy list then remove when finding said mods
				var consideredConflict = false
				if triggers:
					var check
					if checkForNull(newVer) == "any":
						consideredConflict = true
					else:
						var afterMinimum = false
						var minimum = checkForNull(minVersion)
						if minimum == "any":
							afterMinimum = true
						elif newVer >= minimum:
							afterMinimum = true
						var beforeMaximum = false
						var maximum = checkForNull(maxVersion)
						if maximum == "any":
							beforeMaximum = true
						elif newVer <= maximum:
							beforeMaximum = true
						if beforeMaximum or afterMinimum:
							consideredConflict = true
				if not consideredConflict and not depMods.has(zip):
					loopCount = zip
					return {loopCount:[newID, newName, newZip, newVer]}
				else:
					return false
	return false




#
#func _has_finished_validating_mods():
#	checkForConflictsFile(nodeName)
#	print("registered signal")


	
	

func testDictionaries():
	var dict1 = {
	"~|multiple|~": {
		"id": "hev.DerelictDelights",
		"name": "Derelict Delights",
		"zip": "DerelictDelights-2.0.7.zip",
		"minVersion": "2.0.3",
		"maxVersion": "2.0.7",
		"id_2": "hev.IndustriesOfEnceladus",
		"name_2": "",
		"zip_2": "IndustriesOfEnceladusRevamp.zip",
		"minVersion_2": "",
		"maxVersion_2": "2.1.1"
	},
	"1": {
		"id": "",
		"name": "",
		"zip": "YeetProtocol.zip",
		"minVersion": "",
		"maxVersion": ""
	}
}




func checkForNull(expression):
	match expression.to_lower():
		"":
			return "any"
		"null":
			return "any"
		null:
			return "any"
		"unknown":
			return "any"
		"any":
			return "any"
		0:
			return "any"
		"0":
			return "any"
		"x":
			return "any"
		"*":
			return "any"
		_:
			return expression
		
