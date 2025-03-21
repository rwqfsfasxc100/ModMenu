extends Button

var updateDir = "user://.Mod_Menu_Cache/updatecache/mod.updates"

func _ready():
	visible = false

func _physics_process(delta):
	var thisModData = get_parent().get_parent().get_parent().editor_description
	var file = File.new()
	file.open(updateDir, File.READ)
	var currentUpdates = file.get_as_text()
	file.close()
	var mods = currentUpdates.split("\n")
	var currentMod = thisModData.split("\n")
	for mod in mods:
		if mod == "":
			return
		var data = mod.split("~||~")
		if data[2] > currentMod[4] and data[0] == currentMod[15]:
			visible = true
