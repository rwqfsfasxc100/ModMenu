extends Node

var Globals = preload("res://ModMenu/Globals.gd").new()

const modButton = preload("res://ModMenu/menu/buttons/ModButtonAdvanced.tscn")

signal has_finished_validating_mods

var modDependancy = ModLoader._modZipFiles
var tempFolderPath = "user://cache/.Mod_Menu_Cache/"
var hasModMenuTemp = false
var currentModCache = tempFolderPath + "updatecache/currentmods/"

func _ready():	
	clearUpdateCache()
	sortCache()
	getMods()
	getModList()
	if get_child_count() >= 1:
		var NetHandle = load("res://ModMenu/menu/netcode/NetHandles.tscn").instance()
		get_parent().call_deferred("add_child",NetHandle)
	
var modLists = []

var modDirectory = {}

func getMods():
	Debug.l("Mod Menu: Fetching zip files from the ModLoader process")
	var state = ""
	for mod in modDependancy:
		if state == "":
			state = "\n" + mod
		else:
			state = state + ",\n" + mod
	Debug.l("Mod Menu: Mod zips found from the ModLoader process: %s" % state)
	for modDir in modDependancy:
		var zipName = modDir.split("/")[modDir.split("/").size()-1]
		var modTruncate = zipName.split(".zip")
		var modData = Globals.__get_mod_main(modDir, true)
		var modNameDespace = modData[0].split(" ")
		var modNameDespaceSize = modNameDespace.size()
		var modNamePatched = "".join(modNameDespace)
		var nameFormatted = modNamePatched + "~" + modData[2]
		var button = modButton.instance()
		var modDataConjoin = "\n".join(modData)
		if modData != null:
			button.editor_description = str(modDataConjoin)
			button.set_name(nameFormatted)
		else:
			button.set_name(modTruncate[0])
			button.text = modTruncate[0]
			
		add_child(button)
		modLists.append(modData[0])
		if not modData[15] == "MODMENU_ID_PLACEHOLDER":
			var modDataDict = {
				modData[15]:
					[
						modData[0],
						modData[1],
						modData[4],
					]
			}
			modDirectory.merge(modDataDict)
		var buttonFolder = "res://" + modData[3] + "/ModMenu/button/"
		var dirCheck = Directory.new()
		if dirCheck.open(buttonFolder) == OK:
			var menuItem = load("res://" + modData[3] + "/ModMenu/menu/" + modData[3] + "Menu.tscn")
			if not menuItem == null:
				var initMenu = menuItem.instance()
				initMenu.name = modData[3]
				if get_parent().get_parent().get_parent().get_node("NoMargins").add_child(initMenu) == OK:
					continue
		Debug.l("Added %s to ModMenu list" % zipName)
	writeDict()
	addDLCLabel()
	self.editor_description = "validModsVerified"

var manifestDict = {}


func getModList():
	var childCount = get_child_count()
	var currentChildNo = 0
	while currentChildNo < childCount:
		var childNodeData = get_child(currentChildNo).editor_description.split("\n")
		currentChildNo += 1
		if not childNodeData[15] == "MODMENU_ID_PLACEHOLDER":
			var dictForMerger = {
						childNodeData[15]: [
							childNodeData[0],
							childNodeData[1],
							childNodeData[3],
							childNodeData[4],
							childNodeData[6],
							childNodeData[7],
							Time.get_datetime_string_from_system()
							]
					}
			manifestDict.merge(dictForMerger)
		var modList = get_parent().get_node("InstalledMods").editor_description
		var validMods = get_parent().get_node("InstalledModsWithValidIDs").editor_description
		
		
		if not childNodeData[15] == "MODMENU_ID_PLACEHOLDER":
			modList = modList.to_lower() + childNodeData[15].to_lower() + "~||~" + childNodeData[1].to_lower() + "~||~" + childNodeData[4].to_lower() + "\n"
			get_parent().get_node("InstalledModsWithValidIDs").editor_description = validMods + childNodeData[15].to_lower() + "~||~" + childNodeData[1].to_lower() + "~||~" + childNodeData[4].to_lower() + "~||~" + childNodeData[7] + "\n"
		else:
			modList = modList.to_lower() + childNodeData[0].to_lower() + "~||~" + childNodeData[1].to_lower() + "~||~" + childNodeData[4].to_lower() + "\n"
		get_parent().get_node("InstalledMods").editor_description = modList


func sortCache():
	Globals.__check_folder_exists(tempFolderPath)

var labelArray = []

func addDLCLabel():
	var modString = ""
	if modLists.size() >=1:
		for m in modLists:
			if modString == "":
				modString = m
			else:
				modString = modString + "\n" + m
		Globals.__check_folder_exists("user://cache/.Mod_Menu_Cache/")
		var file = File.new()
		file.open("user://cache/.Mod_Menu_Cache/mods_used_at_last_runtime.txt",File.WRITE)
		file.store_string(modString)
		file.close()
	if modDependancy.size() >= 1:
		if Settings.ModMenu["mainSettings"]["displayLocation"] == 0 and Settings.loadedExtensions.size() >= 1:
			labelArray.append(TranslationServer.translate("MODMENU_DLCLIST_MODSEPARATOR") % modDependancy.size())
		else:
			labelArray.append(TranslationServer.translate("MODMENU_TOOLTIPLIST_MODSEPARATOR") % modDependancy.size())
	labelArray.append_array(modLists)
	if Settings.ModMenu["mainSettings"]["displayLocation"] == 0:
		for m in labelArray:
			var label = load("res://ModMenu/menu/buttons/display/DLCLabel.tscn").instance()
			label.text = m
			get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_node("DLClist").add_child(label)
	if Settings.ModMenu["mainSettings"]["displayLocation"] == 1:
		for m in labelArray:
			var label = load("res://ModMenu/menu/buttons/display/ModLabel.tscn").instance()
			label.text = m
			get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_node("MODLIST").add_child(label)
	
	
	
	if Settings.ModMenu["mainSettings"]["displayLocation"] == 99:
		var string = ""
		for m in modLists:
			if string == "":
				string = m
			else:
				string = string + "\n" + m
		var buttonNode = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_node("MarginContainer/VBoxContainer/MarginContainer2/GridContainer/ModMenu")
		buttonNode.editor_description = string

func clearUpdateCache():
	Globals.__check_folder_exists(currentModCache)
	Globals.__check_folder_exists("user://cache/.Mod_Menu_Cache/updatecache/")
	Globals.__check_folder_exists("user://cache/.Mod_Menu_Cache/updatecache/downloaded_zips/")
	Globals.__check_folder_exists("user://cache/.Mod_Menu_Cache/conflicts/")
	Globals.__check_folder_exists("user://cache/.Mod_Menu_Cache/updated_zips/")
	var file = File.new()
	file.open("user://cache/.Mod_Menu_Cache/updatecache/mod.updates", File.WRITE)
	file.store_string("")
	file.close()
	var file2 = File.new()
	file2.open("user://cache/.Mod_Menu_Cache/conflicts/validmods.modmenucache", File.WRITE)
	file2.store_string("")
	file2.close()
	var file3 = File.new()
	file3.open("user://cache/.Mod_Menu_Cache/conflicts/conflicts.modmenucache", File.WRITE)
	file3.store_string("")
	file3.close()
	var file4 = File.new()
	file4.open("user://cache/.Mod_Menu_Cache/conflicts/dependancies.modmenucache", File.WRITE)
	file4.store_string("")
	file4.close()
	var dircheck = true
	var zipDir = "user://cache/.Mod_Menu_Cache/updated_zips"
	var dir = Directory.new()
	if dir.open(zipDir) != OK:
		Debug.l("Mod Menu: Can't open mod cache folder %s." % zipDir)
		dircheck = false 
	if dir.list_dir_begin() != OK:
		Debug.l("ModLoader: Can't read mod folder %s." % zipDir)
		dircheck = false 
	var dirList = []
	if dircheck:
		dir.list_dir_begin()
		while true:
			var fileName = dir.get_next()
			if fileName == "":
				break
			if dir.current_is_dir():
				continue
			dirList.append(fileName)
		dir.list_dir_end()
		for f in dirList:
			dir.remove(f)
	var directory = Directory.new()
	var dZip = "user://cache/.Mod_Menu_Cache/updatecache/downloaded_zips"
	var dCheck = true
	if directory.open(dZip) != OK:
		Debug.l("Mod Menu: Can't open mod cache folder %s." % dZip)
		dCheck = false 
	if directory.list_dir_begin() != OK:
		Debug.l("ModLoader: Can't read mod folder %s." % dZip)
		dCheck = false 
	var dList = []
	if dCheck:
		directory.list_dir_begin()
		while true:
			var fileName = directory.get_next()
			if fileName == "":
				break
			if directory.current_is_dir():
				continue
			dList.append(fileName)
		directory.list_dir_end()
		for f in dList:
			directory.remove(f)
			
func writeDict():
	var conflictsDir = "user://cache/.Mod_Menu_Cache/conflicts/"
	var file = File.new()
	file.open(conflictsDir + "validmods.modmenucache", File.WRITE)
	file.store_string(JSON.print(modDirectory))
	file.close()
	var modNodes = get_children()
	var modNames = []
	for mod in modNodes:
		modNames.append(mod.name)
		var conflict = mod.get_node("VBoxContainer/Icon/CONFLICTBUTTON")
		var mdep = mod.get_node("VBoxContainer/Icon/MISSINGDEPSBUTTON")
#		var child = mod.get_children()[0].get_children()[0].get_children()[0]
		connect("has_finished_validating_mods",conflict,"_has_finished_validating_mods")
		connect("has_finished_validating_mods",mdep,"_has_finished_validating_mods")


	emit_signal("has_finished_validating_mods")
