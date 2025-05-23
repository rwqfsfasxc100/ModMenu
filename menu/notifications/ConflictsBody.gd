extends Label


var updateDir = "user://cache/.Mod_Menu_Cache/conflicts/conflicts.modmenucache"

func _ready():
	text = TranslationServer.translate("MODMENU_NOTIFICATIONS_LABEL_NONE")
	modulate = "777777"

func _physics_process(delta):
	getModData()

func getModData():
	var updateList = ""
	var file = File.new()
	file.open(updateDir, File.READ)
	var currentUpdates = file.get_as_text()
	file.close()
	var mods = currentUpdates.split("\n")
	for mod in mods:
		if mod == "":
			return
		var d = mod.split("|~")[0]
		var data = d.split("~|")
		if updateList == "":
			updateList = data[1]
		else:
			updateList = updateList + "\n" + data[1]
	if not updateList == "":
		text = updateList
		
		modulate = "ffffff"
	else:
		modulate = "777777"
		text = TranslationServer.translate("MODMENU_NOTIFICATIONS_LABEL_NONE")
