extends Label


var updateDir = "user://cache/.Mod_Menu_Cache/conflicts/dependancies.modmenucache"

func _ready():
	var updateCounter = 0
	text = TranslationServer.translate("MODMENU_NOTIFICATIONS_MISSING_DEPS") % updateCounter
	modulate = "777777"

func _physics_process(delta):
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
		text = TranslationServer.translate("MODMENU_NOTIFICATIONS_MISSING_DEPS") % updateCounter
		
		modulate = "ffffff"
	else:
		modulate = "777777"
