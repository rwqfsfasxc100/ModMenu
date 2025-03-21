extends Label


var updateDir = "user://.Mod_Menu_Cache/updatecache/mod.updates"

func _ready():
	visible = false

func _process(delta):
	getModData()

func getModData():
	var updateCounter = 0
	var file = File.new()
	file.open(updateDir, File.READ)
	var currentUpdates = file.get_as_text()
	file.close()
	var mods = currentUpdates.split("\n")
	for mod in mods:
		if mod == "":
			return
		var data = mod.split("~||~")
		updateCounter += 1
	if updateCounter >= 1:
		text = TranslationServer.translate("MODMENU_TITLE_X_UPDATES_AVAILABLE") % updateCounter
		visible = true
	else:
		visible = false



func _on_UpdateLabel_visibility_changed():
	getModData()
