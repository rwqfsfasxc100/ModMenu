extends HBoxContainer

var updateDir = "user://cache/.Mod_Menu_Cache/conflicts/dependancies.modmenucache"

export var hasMissingDependancies = false

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
		visible = true
		hasMissingDependancies = true
	else:
		visible = false
		hasMissingDependancies = false

func _on_MISSINGDEPS_visibility_changed():
	
	getModData()
