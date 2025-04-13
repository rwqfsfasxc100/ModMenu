extends Button

onready var modData = get_parent().editor_description.split("\n")
var focusFixed = false

func _ready():
	writeVars()
var zipString = ""
var modID = ""
func writeVars():
	var gameInstallDirectory = OS.get_executable_path().get_base_dir()
	if OS.get_name() == "OSX":
		gameInstallDirectory = gameInstallDirectory.get_base_dir().get_base_dir().get_base_dir()
	
	var modDir = gameInstallDirectory + "/mods/"
	var zipListType = Settings.ModMenu["mainSettings"]["zipNameDisplay"]
	if zipListType == 0:
		zipString = "\n" + TranslationServer.translate("MODMENU_MOD_ZIPFILE") + modData[1]
	if zipListType == 1:
		zipString = "\n" + TranslationServer.translate("MODMENU_MOD_ZIPFILE_FULL") + modDir + modData[1]
	if zipListType == 2:
		zipString = ""
	get_node("Label").text = modData[0]
	if not modData[15] == "MODMENU_ID_PLACEHOLDER":
		modID = TranslationServer.translate("MODMENU_ID_LABEL") % str(modData[15])
	else:
		modID = TranslationServer.translate("MODMENU_ID_PLACEHOLDER")
	
	get_node("Tooltip").editor_description = modData[0] + "\n" + modID + zipString

func _process(delta):
	if get_parent().get_parent().editor_description == "validModsVerified" and not focusFixed:
		ensureProperFocus()
	var tooltip = Settings.ModMenu["mainSettings"]["accessibleTooltips"]
	if tooltip == 0:
		hint_tooltip = modData[0] + "\n" + modID + zipString
	else:
		hint_tooltip = ""
	
	var iconNode = get_parent().get_node("VBoxContainer/Icon")
	if iconNode.get_node("MISSINGDEPSBUTTON").visible == true:
		focus_neighbour_left = get_path_to(iconNode.get_node("MISSINGDEPSBUTTON"))
	elif iconNode.get_node("MISSINGDEPSBUTTON").visible == false and iconNode.get_node("CONFLICTBUTTON").visible == true:
		focus_neighbour_left = get_path_to(iconNode.get_node("CONFLICTBUTTON"))
	elif iconNode.get_node("MISSINGDEPSBUTTON").visible == false and iconNode.get_node("CONFLICTBUTTON").visible == false and iconNode.get_node("UPDATEBUTTON").visible == true:
		focus_neighbour_left = get_path_to(iconNode.get_node("UPDATEBUTTON"))
	else:
		focus_neighbour_left = ""


func ensureProperFocus():
	if get_parent().get_parent().get_child_count() > 1:
		var pos = get_parent().get_position_in_parent()
		var modCount = get_parent().get_parent().get_child_count()
		if pos >= 1 and pos <= modCount - 2:
			focus_neighbour_top = get_path_to(get_parent().get_parent().get_child(pos - 1).get_node("MODNAME"))
			focus_neighbour_bottom = get_path_to(get_parent().get_parent().get_child(pos + 1).get_node("MODNAME"))
		
		if pos == 0:
			focus_neighbour_top = ""
			focus_neighbour_bottom = get_path_to(get_parent().get_parent().get_child(pos + 1).get_node("MODNAME"))
		if pos == modCount - 1:
			focus_neighbour_bottom = ""
			focus_neighbour_top = get_path_to(get_parent().get_parent().get_child(pos - 1).get_node("MODNAME"))
		focusFixed = true
		
	
