extends Node

func _ready():
	addDLCLabel()

var labelArray = []

func addDLCLabel():
	var file = File.new()
	file.open("user://cache/.Mod_Menu_Cache/mods_used_at_last_runtime.txt",File.READ)
	var modLists = file.get_as_text().split("\n")
	file.close()
	if Settings.ModMenu["mainSettings"]["displayLocation"] == 0 and Settings.loadedExtensions.size() >= 1:
		labelArray.append(TranslationServer.translate("MODMENU_DLCLIST_MODSEPARATOR") % modLists.size())
	else:
		labelArray.append(TranslationServer.translate("MODMENU_TOOLTIPLIST_MODSEPARATOR") % modLists.size())
	labelArray.append_array(modLists)
	if Settings.ModMenu["mainSettings"]["displayLocation"] == 0:
		for m in labelArray:
			var label = load("res://ModMenu/menu/buttons/display/DLCLabel.tscn").instance()
			label.text = m
			get_parent().get_node("DLClist").add_child(label)
	if Settings.ModMenu["mainSettings"]["displayLocation"] == 1:
		for m in labelArray:
			var label = load("res://ModMenu/menu/buttons/display/ModLabel.tscn").instance()
			label.text = m
			get_parent().get_node("MODLIST").add_child(label)
	
